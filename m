Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbXICIhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbXICIhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbXICIg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:36:59 -0400
Received: from www.osadl.org ([213.239.205.134]:57572 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756289AbXICIg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:36:57 -0400
Subject: Re: 2.6.23-rc4-mm1: boot failure on HPC nx6325
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <200709022239.14175.rjw@sisk.pl>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	 <200709022239.14175.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 03 Sep 2007 10:36:40 +0200
Message-Id: <1188808600.5698.9.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-02 at 22:39 +0200, Rafael J. Wysocki wrote:
> On Saturday, 1 September 2007 06:58, Andrew Morton wrote:
> > - dynticks-for-x86_64 has returned
> 
> It fails to boot on my HPC nx6325 (hangs very early, before any messages reach
> the console), because of this patch:
> 
> x86_64-convert-to-clockevents.patch

Sigh. Can you try

noapictimer
nohpet

on the kernel commandline please ?

Also it would be interesting whether the -hrt patchset on top of rc5 has
the same problem:

http://www.tglx.de/projects/hrtimers/2.6.23-rc5/patch-2.6.23-rc5-hrt1.patches.tar.bz2

Thanks,

	tglx


