Return-Path: <linux-kernel-owner+w=401wt.eu-S1761115AbZE1IVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761115AbZE1IVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbZE1IUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:20:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:39959 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbZE1IUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:20:50 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Timur Tabi <timur@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <4A1DB855.2030608@firmworks.com>
References: <1243408083.13460.14.camel@debian-nb>
	 <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	 <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <4A1DB855.2030608@firmworks.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 18:17:41 +1000
Message-Id: <1243498661.3171.167.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 06:01 +0800, Mitch Bradley wrote:
> If anybody is interested, the core ARM support has been added to the 
> Open Firmware tree at svn://openfirmware.info/openfirmware - the same 
> version of OFW that's used on OLPC - under an MIT-style license. This is 
> a full-featured Open Firmware whose lineage traces back to the original 
> Open Boot implementation that I wrote for Sun starting in 1987.
> 
> It's not yet fully elaborated for specific platforms and devices, but it 
> does contain all the core IEE1275 device tree stuff and the standard 
> support packages.  It gets you to an ok prompt on Beagle Board and 
> Gumstix Overo systems.  The source-level and assembly-language debuggers 
> are fully functional. As currently configured on those systems, you can 
> load it into memory either via u-boot or instead of u-boot.
> 
> This base ARM port, while newly released as FOSS, is quite solid, having 
> been developed some years ago for the Digital (RIP) DNARD system.
> 
> I'd be happy to work with people to add deeper support for specific 
> device and platforms.

That's actually great news !

While most of the discussion here revolves around whether to use a
device-tree or not, mostly with the flattened device-tree format in
mind, having a real OF implementation is always a much better option
as far as I'm concerned.

Cheers,
Ben.


