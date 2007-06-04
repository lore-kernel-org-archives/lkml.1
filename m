Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbXFDSYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbXFDSYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbXFDSY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:24:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41646 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbXFDSY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:24:26 -0400
Date: Mon, 4 Jun 2007 20:24:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matt Keenan <tank.en.mate@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Andi Kleen <andi@firstfloor.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <20070604182422.GA14275@one.firstfloor.org>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <Pine.LNX.4.64.0706021610210.19116@p34.internal.lan> <4662869A.9030700@gmail.com> <200706040840.21593.jbarnes@virtuousgeek.org> <2c0942db0706040848y1d1c2ce9p521c65117244edf1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0706040848y1d1c2ce9p521c65117244edf1@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ick. Systems that used to boot fine would then panic on a kernel
> upgrade. That's rather rude for a condition that's merely an
> optimization (using all memory), rather than one of correctness. A
> panic seems entirely inappropriate.

No, when the MTRRs are wrong they would generally not work fine.
As soon as something uses the uncached memory things go incredibly
slow, slow enough to make the machine unusable. Sometimes you're
lucky and nothing important is in there, but only sometimes.

There is also no code in there currently to automatically limit
the memory; the user has to do that with mem=...

But I also don't like the panic.

-Andi
