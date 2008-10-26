Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYJZTIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYJZTIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 15:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYJZTHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 15:07:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbYJZTHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 15:07:52 -0400
Date: Sun, 26 Oct 2008 12:06:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Mikko C." <mikko.cal@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug in workqueues [was: Usb devices randomly aren't detected
 with 2.6.28-rc1-git1]
In-Reply-To: <4904BE67.5000603@gmail.com>
Message-ID: <alpine.LFD.2.00.0810261204370.5200@nehalem.linux-foundation.org>
References: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org> <200810261855.47580.rjw@sisk.pl> <alpine.LFD.2.00.0810261057290.5200@nehalem.linux-foundation.org> <200810261914.40825.rjw@sisk.pl> <alpine.LFD.2.00.0810261117030.5200@nehalem.linux-foundation.org>
 <4904B6CC.7000403@gmail.com> <alpine.LFD.2.00.0810261133150.5200@nehalem.linux-foundation.org> <4904BE67.5000603@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Oct 2008, Mikko C. wrote:
> 
> I guess next time I'll be more patient and wait a little more before trying a
> new kernel as soon as it's out :P

No, no, please do test. It's how we find these things. It got missed on 
most machines just because if you happened to have suspend enabled (or 
just hotplugging cpus in general), the cpu hotplug code would hide the 
problem.

So having people test things with their odd configs is all good. Even if 
it inevitably causes some wasted effort too...

		Linus
