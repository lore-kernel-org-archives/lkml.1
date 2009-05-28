Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbZE1NjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbZE1NjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZE1NjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:39:02 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:53382 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbZE1NjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:39:00 -0400
MIME-Version: 1.0
In-Reply-To: <1243495925.3171.134.camel@pasglop>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <1243495925.3171.134.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 28 May 2009 07:38:42 -0600
Message-ID: <fa686aa40905280638k6cf76a21x3151ef12607022b3@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 1:32 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> Nowadays, any struct device can be linked to an OF device node thanks to
> the archdata extension that we added to the generic struct device. One
> of the idea we have in mind is to create a simple mechanism that
> "intanciate" devices based on probing them in the tree, regardless of
> the actual bus and linux device "type" (platform, PCI, i2c, ...).

Which is actually exactly what happens now for i2c, spi and (in .31)
mdio.  of_platform is the exception.  a really big elephant of an
exception, but an excpection never the less.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
