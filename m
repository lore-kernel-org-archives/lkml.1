Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbXFRD2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbXFRD2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 23:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXFRD2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 23:28:08 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:64936 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbXFRD2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 23:28:07 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Mon, 18 Jun 2007 11:27:59 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C527171@zch01exm26.fsl.freescale.net>
In-Reply-To: <2e7b08497aae9219233aed72628e46c6@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Thread-Index: AceuWPBiFUeW1xK7SnexCZhGNmJ0kQC/bcPQ
References: <11816389393593-git-send-email-wei.zhang@freescale.com> <1181638939310-git-send-email-wei.zhang@freescale.com> <39c7d60cebf03badd106d7f75a08f449@kernel.crashing.org> <46B96294322F7D458F9648B60E15112C526DD9@zch01exm26.fsl.freescale.net> <59453d80f2f111b72e8f24e7b489c23e@kernel.crashing.org> <CF39A363-25C6-4780-96EC-6750D77C287F@kernel.crashing.org> <2e7b08497aae9219233aed72628e46c6@kernel.crashing.org>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Kumar Gala" <galak@kernel.crashing.org>
Cc: <mporter@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>, <paulus@samba.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kumar and Segher, 

>
> > "..8641.." "..8641d.." "..8548.." "..8548e.." "..8543.." 
> "..8543e.." 
> > "..8572.." "..8572e.." "..8567.." "..8567e.." "..8568.." "..8568e.."
> 
> You don't need to mention _all_ compatible devices in
> the "compatible" property, only the few that matter;
> typically the oldest one, and sometimes some intermediate
> device that has extra features over the original one.
> 

The oldest one is difficult to find out sometime. Can we only set the
self name in dts, such as "fsl, rapidio-8641", and add this 'compatible'
property to the driver ids arrays? Such as:

static struct of_device_id of_rio_rpn_ids[] = {
	{ .compatible = "fsl, rapidio-8540",},
	{ .compatible = "fsl, rapidio-8560",},
	{ .compatible = "fsl, rapidio-8641",},
	{ .compatible = "fsl, rapidio-8548",},
	{},
};

How about that?

> It isn't useful to add "compatible" entries that no OS
> probes for.
> 
> >> Concrete names are good.
> >
> > While I agree concrete names are good, we put these 'blocks' in so 
> > many devices that using the device to match on is pointless.
> 
> You *definitely* should put the device name for _this_
> device in there, in case it needs some special workaround.
> 
> > I'm all for making up a name like 'Grande', 'Del', 
> 'Janeiro'.  This is 
> > effective what we did with gianfar.  The name gets picked up pretty 
> > quickly by people.
> 
> That can be used as the "base" name, yes.
> 

Do you have the name list? I can change my codes according them.

How about 'Mercurary', 'Venus', 'Earth', 'Mars', 'Saturn', 'Jupiter',
'Uranus', 'Neptune',
Or 'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra',
'Scorpius', 'Sagittarius', 'Capricornus', 'Aquarius', 'Pisces' ?

Thanks!
Wei.
