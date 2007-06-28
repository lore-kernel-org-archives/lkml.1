Return-Path: <linux-kernel-owner+w=401wt.eu-S1763493AbXF1GnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763493AbXF1GnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759166AbXF1GnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:43:05 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:54394 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128AbXF1GnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:43:04 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/5 v2] Add the platform device support with RapidIO to MPC8641HPCN platform.
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 28 Jun 2007 14:42:39 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C6F31B2@zch01exm26.fsl.freescale.net>
In-Reply-To: <200706272256.16418.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/5 v2] Add the platform device support with RapidIO to MPC8641HPCN platform.
Thread-Index: Ace4/cMmKK02Wl/2Q0CJ0wJ2k/mDeQAUWr/w
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <11829333481375-git-send-email-wei.zhang@freescale.com> <1182933348216-git-send-email-wei.zhang@freescale.com> <200706272256.16418.arnd@arndb.de>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Arnd Bergmann" <arnd@arndb.de>, <linuxppc-dev@ozlabs.org>
Cc: <mporter@kernel.crashing.org>, <paulus@samba.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnd,


> 
> On Wednesday 27 June 2007, Zhang Wei wrote:
> > +static struct of_device_id mpc86xx_of_ids[] = {
> > +       { .type = "soc", },
> > +       { .compatible = "fsl,rapidio-delta", },
> > +       {},
> > +};
> > +
> > +static __init int mpc86xx_of_device_init(void)
> > +{
> > +       return of_platform_bus_probe(NULL, mpc86xx_of_ids, NULL);
> > +}
> 
> This will add any devices below the "fsl,rapidio-delta" device
> as an of_device. Is that what you actually want? I would guess that
> you want to add the bridge itself, not the devices below it.
> 
> Is the rapidio device at the root of the device tree, and if so, why
> not under the soc bus?
> 

RapidIO is rather a bus that a device although these is no other nodes defined in its sector now.

Thanks!
Wei.
