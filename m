Return-Path: <linux-kernel-owner+w=401wt.eu-S966899AbXEGU7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966899AbXEGU7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966630AbXEGU7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:59:47 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:6510 "EHLO
	outbound4-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966621AbXEGU7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:59:46 -0400
X-BigFish: VP
X-FB-SS: 0
Message-ID: <463F93FB.1000908@am.sony.com>
Date: Mon, 07 May 2007 14:02:51 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       dirk.behme@googlemail.com, linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Need help debugging RT-preempt patch
References: <463F7449.2020509@am.sony.com> <1178569719.3164.6.camel@imap.mvista.com>
In-Reply-To: <1178569719.3164.6.camel@imap.mvista.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2007 20:59:44.0143 (UTC) FILETIME=[A36571F0:01C790EA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> Are you sure you don't have HardIRQS in Threads enabled? Also are you
> sure the kernel boots without the rt patch applied.

Yes on both counts.  I double-checked the configs.  I'm using quilt
and the RT patch is at the end of my series, so it was easy to
pop the patch and try again (module .config fixups).

I may take a few more blind stabs at different configs before
I go diving into the networking code trying to trace something.
(or before starting to bisect the patch).  Bisecting the patch
will be a bit painful since it's currently an all-in-one.

> 
> ARM is supported, but specific boards are hit or miss.. 
> 
> I've had OMAP working _in the past_ with this patch applied,
> 
> http://lkml.org/lkml/2006/12/10/59
> 
> There was also a patch released on one of the OMAP lists a while back
> from Dirk Behme to get OMAP working on a mor recent rt release..

OK.  This is REALLY helpful info.  I'll take a look.

Thanks very much!!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Electronics
=============================

