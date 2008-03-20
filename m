Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYCTMUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYCTMUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 08:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYCTMUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 08:20:30 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:59036 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752951AbYCTMU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 08:20:29 -0400
Subject: Re: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
From: Laurent GUERBY <laurent@guerby.net>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1205678588.15075.563.camel@localhost>
References: <1205013615.15075.409.camel@localhost>
	 <1205678588.15075.563.camel@localhost>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 13:20:19 +0100
Message-Id: <1206015619.15075.666.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 82.235.162.148 (gut75-4-82-235-162-148.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
X-Ovh-Tracer-Id: 7648238067782262295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-16 at 15:43 +0100, Laurent GUERBY wrote:
> On Sat, 2008-03-08 at 23:00 +0100, Laurent GUERBY wrote:
> > Hi,
> > 
> > I have a system with an "AMD64 Phenom 9500" quad core cpu, 4GB RAM,
> > "ASUS M3A32 MVP Deluxe wifi" motherboard with latest vendor BIOS
> > (0801).
> > 
> > I tried stock debian etch kernel (Debian 2.6.18.dfsg.1-18etch1),
> > machine
> > froze with no message, debian etch backport kernel same, and then
> > Debian 2.6.24-4 from unstable and I got some messages: machine
> > is not frozen but some userland processes are (ps says "Dl" state
> > with child in "Zs" state) and "events/3" is taking 100% cpu
> > according to top:
> > 
> >    18 root      15  -5     0    0    0 R  100  0.0  74:59.46
> > events/3  
> > 
> > Got to the same state with ubuntu hardy 2.6.24-8-server kernel. All
> > kernels are untainted, no X running anyway.
> > 
> > It takes a few hours of doing some stuff, in my case bootstraping or
> > testing GCC at -j 4, and then the problem happens.
> 
> On 2.6.24-1-amd64 (Debian 2.6.24-4) I got a slightly different
> backtrace in /var/log/messages after a few hours of stressing the
> machine with compilations, see below. The given process
> was stuck and unkillable.
> 
> Any idea on what to do/try?

I changed motherboard and went for a (way cheaper but older) ASUS M2A-VM
with is based on the AMD 690G chipset with the exact same
kernel/phenom/memory/disk/box and installed the latest vendor BIOS
(1604). It took longer (25 hours) to get a stuck and unkillable process
but it did happen, but I got nothing in /var/log/kern.log this time.

In order to rule out a motherboard or memory issue I bought an Athlon X2
4400+ EE and put in replacement of the phenom with the exact same
kenel/memory/disk/box and my stress test has been running for 72 hours
without any issue so far.

So in the end it seems to be a problem specific to phenom 9500 with the
linux kernel.

Did anyone succeed in getting a stable linux box based on a phenom 9500
processor ? "Stable" defined as being able to survive a few days
compiling at -j4 (this is for the GCC compile farm after all :).

If so I'm interested by the exact motherboard/bios version/kernel
version/distro used.

As proposed in my first email, ssh root access is possible to my machine
(with either motherboard).

Thanks in advance,

Laurent


