Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYAICZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYAICZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYAICZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:25:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:54955 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbYAICZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:25:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J+Bd846i0QaHvKpPanwx81xnTN6pLfnDJYTm7s4Zo00x6r4AY/vchjIeRtCO1aMpStmmjpzuyrXpDHlsQWtQ4q6pssItEPeRxQXASEBFwyTofJlinw8eTVJAaWZHfi6xCJznGrwhtrsZoRx0zS92OTUmjqfkEiAFIrxUYtlUM3k=
Message-ID: <6d291e080801081825g951ef59j1eb37d6b43f11ec5@mail.gmail.com>
Date: Tue, 8 Jan 2008 20:25:18 -0600
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Kernel Oops?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080107233008.0c1b928c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d291e080801071515wf7ebbccu744e3e3eca6bb0a9@mail.gmail.com>
	 <20080107233008.0c1b928c@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 7, 2008 5:30 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 7 Jan 2008 17:15:01 -0600
> "Stoyan Gaydarov" <stoyboyker@gmail.com> wrote:
>
> > Today I upgraded my kernel from 2.6.23.9 to 2.6.23.12 and in the past
> > 30 minutes I have had to restart my computer twice.
> > I believe its a kernel oops or a kernel panic because when the
> > computer freezes it blinks the caps and scroll lock LEDs.
> > I don't know what is causing the problem but I am willing to help, I
> > can provide you with any information you need.
> > The only problem is that I don't know how to debug the system myself.
> > If anyone can tell me what to do to I can do it and give back the
> > information.
>
> When the machine hangs in graphical mode its quite hard to get the data
> out - one of the long term todo items is to fix that.
>
> Boot the machine and leave it in text mode (or if it boots to graphical
> mode then switch to a text console/text mode) and wait.. with "luck" it
> will show the same problem in text mode and give you a meaningful screen
> dump you can then write down (or grab with a digital camera)
>
> Alan
>

I reverted back to a clean install of slackware 12.0 after trying to
get it to fail again without luck, then i installed the 2.6.23.9
kernel and continued to use it regularly. Then a few minutes ago it I
restarted the computer because it had frozen again, the same way.
Except this time when rebooting the machine i got a kernel oops
message and it didn't boot completely. I could not copy it but I did
take a picture and now I have re-written the screen here(sorry about
the formating):

Stack: 00000010 000000d0 00000001 000000d0 c20fb980 c2104000 c2103e00 00000246
          c0a32fc0 47807ae8 00000000 c23eeaa0 000000d0 00000282
c20fb980 c026661b
          c23eeaa0 00000000 f586df04 c23eeaa0 c02227f2 00000246
00000000 c225c480
Call Trace:
[<c026661b>] kmem_cache_alloc+0x6b/0x90
[<c02227f2>] dup_fd+0x22/0x2c0
[<c023cc26>] getnstimeofday+0x36/0xc0
[<c0222ad1>] copy_files+0x41/0x60
[<c0223218>] copy_process+0x488/0x11a0
[<c0235a62>] alloc_pid+0x152/0x280
[<c0224196>] do_fork+0x76/0x230
[<c022e7fb>] recalc_sigpending+0x5d/0xe0
[<c022e86d>] sigprocmask+0x5d/0xe0
[<c0202252>] sys_clone+0x32/0x40
[<c02041e6>] syscall_call+0x7/0xb
[<c07f0000>] __mutex_lock_interruptible_slowpath+0xb0/0xc0
=======================
Code: 5b 5e 5f 5d c3 8b 7a 10 89 d0 c7 42 34 01 00 00 00 83 c0 10 39 c7 74 b6 8b
 4c 24 10 8b 77 10 3b b1 98 00 00 00 0f 82 1d ff ff ff <0f> 0b eb fe 8b 4c 24 18
 8b 54 24 18 8b 41 08 83 c2 08 89 78 04
EIP: [<c02667fd>] cache_alloc_refill+0x1bd/0x540 SS:ESP 0068:f586de7c
INIT: Entering runlevel: 4
Going multiuser...
Updating shared library links:  /sbin/ldconfig &


Hope that someone can find the problem and fix it
