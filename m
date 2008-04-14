Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbYDNKYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbYDNKYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbYDNKXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:23:54 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:47314 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755658AbYDNKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:23:53 -0400
Subject: Re: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
From: Laurent GUERBY <laurent@guerby.net>
Reply-To: laurent@guerby.net
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Oruba <peter.oruba@amd.com>
In-Reply-To: <alpine.LFD.1.10.0804131635500.3261@apollo.tec.linutronix.de>
References: <1205013615.15075.409.camel@localhost>
	 <1205678588.15075.563.camel@localhost>
	 <1206015619.15075.666.camel@localhost>  <47E26A5D.40401@amd.com>
	 <1206123836.15075.699.camel@localhost>
	 <1207985304.15628.415.camel@localhost>
	 <alpine.LFD.1.10.0804131635500.3261@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 12:23:47 +0200
Message-Id: <1208168627.15628.462.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 82.235.162.148 (gut75-4-82-235-162-148.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
X-Ovh-Tracer-Id: 3516185409846517271
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fact BIOS 1705 without any boot option seems
to provide a stable machine (51 hours of stress
test without failure). Plus BIOS 1705 has
an explicit TLB fix auto/enable/disable
that the previous BIOS didn't have (even
if TLB fix was on).

So probably it was probably a BIOS bug, we're continuing
the stress testing.

Laurent


On Sun, 2008-04-13 at 16:37 +0200, Thomas Gleixner wrote:
> On Sat, 12 Apr 2008, Laurent GUERBY wrote:
> > Hi,
> > 
> > FYI with Peter off-list help we found a way to make the ASUS M2A-VM with
> > 1604 BIOS stable under my stress test: we just needed nmi_watchdog=1 in
> > the kernel boot options (no other boot option necessary).
> 
> hmm, nmi_watchdog=1 disables the local apic timer. Can you add
> "noapictimer" to the kernel command line instead ?
> 
> Thanks,
> 	tglx
> 

