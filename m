Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbZE1DVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbZE1DVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZE1DV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:21:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:46002 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbZE1DVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <20090527235704.GQ6805@pengutronix.de>
References: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> 
	<20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> 
	<9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> 
	<20090527192116.GA31110@n2100.arm.linux.org.uk> <20090527193927.GD30039@game.jcrosoft.org> 
	<fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com> 
	<20090527235704.GQ6805@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 21:21:07 -0600
Message-ID: <fa686aa40905272021w18a148caqd2b73c4448da2b28@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 5:57 PM, Robert Schwebel
<r.schwebel@pengutronix.de> wrote:
> On Wed, May 27, 2009 at 02:22:50PM -0600, Grant Likely wrote:
>> 2) Driver binding mechanism:  device tree nodes usually have a
>> "compatible" property which is a list of strings. The first string
>> describes exactly what the device is (ie. "atmel,24c08") and an
>> optional list of other devices which it is register interface
>> backwards compatible with.
>
> This is a good example. The "exact" description above doesn't say
> anything about some of the details the driver needs to know. Here is the
> at24 driver:
>
> http://lxr.linux.no/linux+v2.6.29/include/linux/i2c/at24.h#L18
>
> Where do we get the page size & flags from?

It is inherent in the value "atmel,24c08".  Because the exact device
model is specified, the kernel can know what the page size and flags
are for that device.  OTOH, if it is appropriate for the device, then
the binding can be defined to include things like page size and flags
encoded explicitly in additional properties.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
