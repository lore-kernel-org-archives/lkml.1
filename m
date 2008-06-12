Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYFLHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYFLHf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 03:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYFLHfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 03:35:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:46404 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752102AbYFLHfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 03:35:16 -0400
X-Authenticated: #2253541
X-Provags-ID: V01U2FsdGVkX18RLpc/uSIRhmb+YNX6pY975J2Rs/nveAdg8q1J/S
	ZlesWDOGyyCbnE
Date: Thu, 12 Jun 2008 09:35:15 +0200
From: Thomas Bleher <ThomasBleher@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       debian-embedded@lists.debian.org
Subject: Re: ARM on qemu: running kernel 2.6.20 or newer?
Message-ID: <20080612073514.GA31458@j-crew.de>
References: <20080605135149.GA20870@j-crew.de> <200806051644.07430.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806051644.07430.elendil@planet.nl>
X-Accept-Language: de, en
X-Operating-System: Linux 2.6.18 x86_64
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frans Pop <elendil@planet.nl> [2008-06-05 16:44]:
> Thomas Bleher wrote:
> > I'm trying to run an ARM kernel on qemu (0.9.1-5) on a Debian AMD64
> > system. 2.6.19 worked fine, but all newer kernel releases[1] result in
> > qemu consuming 100% of the CPU without ever outputting anything to the
> > console.
> 
> The daily built armel versatile D-I images [1] worked fine for me in qemu 
> just a few days ago. They use 2.6.24. There's one issue [2] related to 
> serial console, but graphics mode works fine.
> 
> [1] http://wiki.debian.org/ArmEabiHowto
> [2] http://bugs.debian.org/484366

Thank you for the fast response!
I did some further tests, and it looks like the Emdebian cross-compiler
miscompiles newer kernels, at least for the configs I tested. Using the
ELDK cross-compiler instead, the kernel boots fine under qemu.

I don't think I'll have time to further debug this issue, but I've cc'ed
debian-embedded@l.d.o, in case anyone is interested in tracking this
down. I'll provide .configs + vmlinux files on request.

Regards,
Thomas Bleher

