Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYEZOly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYEZOly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYEZOlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:41:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:23003 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbYEZOlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:41:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=co5VlvZlKsBEBY9/hhKf2z4LwGkDkjdgQo/W6MhbxID7uHXqAAMPfmn5+NMiPevoHOamSaZj+B8ueYqUUpi3eJyDVD+V5UtFHD8X1j7j3f0Z9TMvzfYahBPHm4SsYGU8BofDAJiEMp83RGpL2YIyS7O1Myi8NcEsppguP6VH4ls=
Date: Mon, 26 May 2008 18:41:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED][X86] next-20080526 hangs on boot
Message-ID: <20080526144134.GA7305@cvg>
References: <g1eg2q$81q$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g1eg2q$81q$1@ger.gmane.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sitsofe Wheeler - Mon, May 26, 2008 at 03:04:54PM +0100]
| <posted & mailed>
| 
| When using a 32 bit linux-next-20080526 the bootup process will hang at a
| random point (not even sysrq helps) with no additional output on the screen
| (whereas linux-next-20080523 did boot). Mysteriously, booting with
| nmi_watchdog=2 allows the boot to finish (booting with nmi_watchdog=1 still
| stalls). I have bisected it down to commit
| [d1b946b97d71423f365fa797d1428e1847c0bec1]:
| 
| commit d1b946b97d71423f365fa797d1428e1847c0bec1
| Author: Cyrill Gorcunov <gorcunov@gmail.com>
| Date:   Sat May 24 19:36:34 2008 +0400
| 
|     x86: nmi_32.c - add "panic" option
| 
|     Allow to pass "panic" option in 32bit mode
| 
|     Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
|     Cc: hpa@zytor.com
|     Cc: mingo@redhat.com
|     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
| 
| Reverting this seemed to allow the boot to proceed without issue. Here is
| the bisection log:
| 

Hi, so it helps by reverting _only_ that commit? I mean all further commits
are still appiled?

		- Cyrill -
