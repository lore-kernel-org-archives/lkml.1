Return-Path: <linux-kernel-owner+w=401wt.eu-S1763035AbZCQKPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035AbZCQKPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760181AbZCQKO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:14:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37734 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbZCQKO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:14:56 -0400
From: "Kumar, Purushotam" <purushotam@ti.com>
To: Trilok Soni <soni.trilok@gmail.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>
Date: Tue, 17 Mar 2009 15:44:38 +0530
Subject: RE: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for
 DaVinci/DM6446.
Thread-Topic: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for
 DaVinci/DM6446.
Thread-Index: AcmmYwPlcsQJPplvRQq3TVZg++rBJQAhcZdQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301CC30E2B1@dbde02.ent.ti.com>
References: <1237214559-31345-1-git-send-email-purushotam@ti.com>
 <5d5443650903161114q4aa63bb9s405031c8a5bd0317@mail.gmail.com>
In-Reply-To: <5d5443650903161114q4aa63bb9s405031c8a5bd0317@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > +/* MMCSD Init clock in Hz in opendain mode */
> s/opendain/opendrain

I will make this modification while incorporating review comments.

> > +static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
> > +{
> > +       struct mmc_davinci_host *host = (struct mmc_davinci_host *)dev_id;
> Unnecessary casting from void *.

I think it always to cast void* pointer and use it.

> 
> > +
> > +       ret = -EBUSY;
> > +       mem_size = r->end - r->start + 1;
> 
> How about using resource_size(...) ?
> 
> > +       mem = request_mem_region(r->start, mem_size, pdev->name);
> > +       if (!mem)
> > +               goto out;

I could use resource_size.


> > +MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("MMC/SD driver for Davinci MMC controller");
> 
> Adding MODULE_AUTHOR and MODULE_ALIAS would be great. You can also add
> MAINTAINERS entry if you want.
I will add MODULE_AUTHOR and MODULE_ALIAS
-Purushotam
