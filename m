Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbZE1HlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbZE1HlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZE1HlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:41:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:51525 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZE1HlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:41:08 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <4A1D8FBA.6040802@freescale.com>
References: <1243408083.13460.14.camel@debian-nb>
	 <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	 <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk>
	 <4A1D6901.2090508@freescale.com>
	 <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <4A1D8FBA.6040802@freescale.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 17:38:41 +1000
Message-Id: <1243496321.3171.141.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 14:08 -0500, Scott Wood wrote:
> But to restate, having external glue to create platform devices from the 
> device tree is fine if that's what you want to do.  We used to do that, 
> but it was a pain compared to keeping everything in one place.  Your 
> experience may differ.

This is a non-solved debate as to what is best. If an existing driver
already has fairly complete platform_device support, it might be best to
just create a glue that fills up the data structure from the DT... 

In any case, all the approaches are possible, the DT stuff doesn't
corner you into a specific one.

Cheers,
Ben.


