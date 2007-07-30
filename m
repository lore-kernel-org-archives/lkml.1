Return-Path: <linux-kernel-owner+w=401wt.eu-S1764517AbXG3I0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764517AbXG3I0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 04:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbXG3I0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 04:26:39 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:35201 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbXG3I0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 04:26:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/5 v3] Add the platform device support with RapidIO to MPC8641HPCN platform.
Date: Mon, 30 Jul 2007 16:26:32 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C74D27B@zch01exm26.fsl.freescale.net>
In-Reply-To: <200707291556.35632.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/5 v3] Add the platform device support with RapidIO to MPC8641HPCN platform.
Thread-Index: AcfSIJU5Frd1VGGfQt6XypeDQR+RRAAYngzg
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393741899-git-send-email-wei.zhang@freescale.com> <11854393753986-git-send-email-wei.zhang@freescale.com> <200707291556.35632.arnd@arndb.de>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Arnd Bergmann" <arnd@arndb.de>, <linuxppc-dev@ozlabs.org>
Cc: <galak@kernel.crashing.org>, <mporter@kernel.crashing.org>,
       <paulus@samba.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnd,

I can change it as you metioned now.

Thanks!
-zw

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Arnd Bergmann
> Sent: Sunday, July 29, 2007 9:57 PM
> To: linuxppc-dev@ozlabs.org
> Cc: Zhang Wei-r63237; galak@kernel.crashing.org; 
> mporter@kernel.crashing.org; paulus@samba.org; 
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 3/5 v3] Add the platform device support 
> with RapidIO to MPC8641HPCN platform.
> 
> On Thursday 26 July 2007, Zhang Wei wrote:
> > +
> > +static struct of_device_id mpc86xx_of_ids[] = {
> > +       { .type = "soc", },
> > +       { .compatible = "fsl,rapidio-delta", },
> > +       {},
> > +};
> 
> With the device tree source you have posted in 2/5, the 
> rapidio node is
> a child of the soc bus, and it doesn't have any children of its own.
> Therefore it is completely equivalent to _only_ add the soc type
> to mpc86xx_of_ids[], as in 
> 
> static struct of_device_id mpc86xx_of_ids[] = {
>        { .type = "soc", },
>        {},
> };
> 
> Even if you intend to add children to the rapidio node in the future,
> I'd think it would be more appropriate to have those scanned by
> the rapidio bus driver, not by of_platform.
> 
> 	Arnd <><
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
