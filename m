Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZFDQRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZFDQRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZFDQQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:16:59 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:45158 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZFDQQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:16:58 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Duane Griffin <duaneg@dghda.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 11:08:27 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain> <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com>
In-Reply-To: <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041108.29557.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Duane Griffin wrote:
> 2009/6/4 Linus Torvalds <torvalds@linux-foundation.org>:
> > On Thu, 4 Jun 2009, Michael S. Zick wrote:
> >> Well, that one isn't anything to brag about"
> >
> > So what's the problem on that machine? Is the VIA C7-M (or some random
> > device in it) just buggy and it eventually hangs, or what? Has _any_
> > kernel ever worked on that machine for longer than an hour or two?
> 
> There have been reports of hangs on various VIA C7 machines going back
> a year now. The version of the kernel doesn't seem to matter, but the
> version of glibc does. Unfortunately there hasn't been much progress
> in getting to the bottom of it.
> 

There have been recent tweaks to the futex service in the
kernel, this might interact with how a particular glibc
expects them to work.

I also add a few tweaks in my local patches to futex.etc,
so it may need more in mainline (un-proven at this point).

It seems to make a difference with pulse-audio - -
which is my "test program".

Mike
> See here (and other linked reports):
> http://bugs.gentoo.org/show_bug.cgi?id=228263
> 
> Cheers,
> Duane.
> 


