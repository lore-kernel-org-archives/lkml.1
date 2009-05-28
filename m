Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbZE1OkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbZE1OkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZE1Oj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:39:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:11932 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZE1Oj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:39:58 -0400
MIME-Version: 1.0
In-Reply-To: <9e4733910905280547w7ee65d40yb4b3ab9559e14dae@mail.gmail.com>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> 
	<4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> 
	<1243496236.3171.140.camel@pasglop> <20090528091513.GA14789@n2100.arm.linux.org.uk> 
	<9e4733910905280547w7ee65d40yb4b3ab9559e14dae@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 28 May 2009 08:39:40 -0600
Message-ID: <fa686aa40905280739u43270779w7023bfceebff230d@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 6:47 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Thu, May 28, 2009 at 5:15 AM, Russell King - ARM Linux
> For ARM the model could be to use the machine number to load a device
> tree built into the kernel (these trees would slowly migrate into the
> firmware). After the device tree is selected the machine specific code
> would add the override function pointers. Unified OF aware device
> drivers would load using the device tree. These drivers would find the
> function pointers and use them to implement machine specific features.

Nagging point: it is not encouraged to move the device tree into the
firmware.  It is useful to *pass* the device tree via the kernel, but
hard linking it in is the way of pain because it makes updates hard.
This is probably what you meant, but I wanted to clarify.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
