Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZCQHak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZCQHak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZCQHaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:30:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58847 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZCQHaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:30:30 -0400
From: "Kumar, Purushotam" <purushotam@ti.com>
To: David Brownell <david-b@pacbell.net>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>
Date: Tue, 17 Mar 2009 13:00:12 +0530
Subject: RE: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for
 DaVinci/DM6446.
Thread-Topic: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for
 DaVinci/DM6446.
Thread-Index: Acmme2xpwtThNa+MQZexWKmuXmdBRQAVqQiQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301CC30E0D7@dbde02.ent.ti.com>
References: <1237214559-31345-1-git-send-email-purushotam@ti.com>
 <200903161408.45897.david-b@pacbell.net>
In-Reply-To: <200903161408.45897.david-b@pacbell.net>
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

> I noticed a newish bug in probe() ...
> 
> On Monday 16 March 2009, Purushotam Kumar wrote:
> > +       if (!pdata || pdata->wires == 4 || pdata->wires == 0)
> > +               mmc->caps |= MMC_CAP_4_BIT_DATA;
> 
> So pdata may be null.  But, if it is, then ...
> 
> > +
> > +       mmc->ops = &mmc_davinci_ops;
> > +       mmc->f_min = 312500;
> > +       mmc->f_max = 25000000;
> > +       if (pdata->max_freq)
> > +               mmc->f_max = pdata->max_freq;
> 
> Oops!
> 
> > +       if (pdata->caps)
> > +               mmc->caps |= pdata->caps;
> 
> Double oops!
> 

I will add NULL checking for pdata.
-Purushotam
