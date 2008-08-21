Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYHUEVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYHUEVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYHUEVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:21:36 -0400
Received: from ozlabs.org ([203.10.76.45]:34367 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbYHUEVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:21:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18604.60738.523963.886786@drongo.ozlabs.ibm.com>
Date: Thu, 21 Aug 2008 14:21:22 +1000
From: Paul Mackerras <paulus@samba.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Robert Richter <robert.richter@amd.com>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>
Subject: Re: powerpc/cell/oprofile: fix mutex locking for spu-oprofile
In-Reply-To: <200808201519.19453.arnd@arndb.de>
References: <1217620879.15667.145.camel@carll-linux-desktop>
	<200808110925.08485.arnd@arndb.de>
	<20080820123944.GQ13011@erda.amd.com>
	<200808201519.19453.arnd@arndb.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann writes:

> Paul, any chance we can still get this into 2.6.27?

Possibly.  We'll need a really good explanation for Linus as to why
this is needed (what regression or serious bug this fixes) and why it
is late.  Can you send me something explaining that?

> I've added the Ack and uploaded it again for you to
> pull from
> 
>  master.kernel.org:/pub/scm/linux/kernel/git/arnd/cell-2.6.git merge

Are you sure you actually managed to update that?

$ git ls-remote master.kernel.org:/pub/scm/linux/kernel/git/arnd/cell-2.6.git merge
f90a87b5f5fa46dc6c556e9267a6f25a95fbef14        refs/heads/merge

and f90a87b5f5fa46dc6c556e9267a6f25a95fbef14 is the same commit from
2008-08-09 that you asked me to pull previously.

Paul.
