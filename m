Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYBMIrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYBMIrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYBMIrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:47:14 -0500
Received: from hpsmtp-eml13.KPNXCHANGE.COM ([213.75.38.113]:38591 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbYBMIrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:47:13 -0500
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [stable 2.6.24] WARNING: at kernel/time/clockevents.c
Date: Wed, 13 Feb 2008 09:47:10 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
References: <200802101440.22118.elendil@planet.nl> <20080212230741.576b8004.akpm@linux-foundation.org> <alpine.LFD.1.00.0802130845380.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802130845380.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802130947.10781.elendil@planet.nl>
X-OriginalArrivalTime: 13 Feb 2008 08:47:11.0140 (UTC) FILETIME=[05DAEE40:01C86E1D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Thomas Gleixner wrote:
> On Tue, 12 Feb 2008, Andrew Morton wrote:
> > On Sun, 10 Feb 2008 14:40:21 +0100 Frans Pop <elendil@planet.nl> wrote:
> > the hrtimer code is preparing an invalid ktime_t.  Note that
> > clockevents_program_event() actually fails when this happens - I am
> > surprised that this is not causing observeable userspace problems.
> >
> > The WARN_ON_ONCE() means that you'll only see this warning once per
> > boot. But the actually error could be happening any number of times
> > without being reported.
> >
> > Looks pretty serious?
>
> Yes. It's the same problem, which got fixed with:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
>;h=62f0f61e6673e67151a7c8c0f9a09c7ea43fe2b5

OK, so probably glibc performs a unit test during build that asks for a long 
sleep. I guess that makes sense.

Thanks Thomas and Andrew.
