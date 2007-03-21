Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbXCULuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbXCULuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXCULuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:50:32 -0400
Received: from www.osadl.org ([213.239.205.134]:37176 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752550AbXCULub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:50:31 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070321113523.GD3785@lazybastard.org>
References: <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
	 <1174338329.13341.633.camel@localhost.localdomain>
	 <20070319223205.GZ4892@waste.org>
	 <1174351366.13341.739.camel@localhost.localdomain>
	 <20070321110528.GC3785@lazybastard.org>
	 <1174476334.10840.49.camel@localhost.localdomain>
	 <20070321113523.GD3785@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 21 Mar 2007 12:57:42 +0100
Message-Id: <1174478263.10840.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 12:35 +0100, Jörn Engel wrote:
> Even if such flashes still contain a bootloader and a kernel, that will
> occupy less than 1% of the device.  Wear leveling across the device is
> fairly pointless here.  This is what I designed LogFS for.

Still you need to have a solution for handling bitflips in those
bootloader and kernel areas.

I don't dispute, that on a Terrabyte solid state disk which is used in a
totally different way, UBI is not necessarily the right tool.

> There is some middle ground where a combination of UBI and LogFS may
> make sense.  LogFS can still make sense for devices as small as 64MiB.
> But I'm not too concerned about that because flashes will continue to
> grow and the advantages of cross-device wear leveling will continue to
> diminish.

Flashes will grow, but this will not change the embedded use case with a
relativly small FLASH and the bootloader / kernel / rootfs / datafs
scenario, where UBI is the right tool to use.

There is no hammer for all nails and I don't see device mapper doing
what UBI does right now.

	tglx


