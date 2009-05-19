Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZESL0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZESL0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZESL0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:26:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58318 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZESL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:26:41 -0400
Date: Tue, 19 May 2009 13:25:03 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] LP3971 PMIC regulator driver (updated and combined version)
In-reply-to: <1242730021.5473.2550.camel@vega.slimlogic.co.uk>
To: "'Liam Girdwood'" <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       kyungmin.park@samsung.com,
       "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <003901c9d874$77e2ad80$67a80880$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcnYbzKt9By0v1H4SDarnh98lgKR7gABLnew
References: <E4D3F24EA6C9E54F817833EAE0D912AC02245E9A11@bssrvexch01.BS.local>
 <20090515092030.GA2202@rakim.wolfsonmicro.main>
 <1242641718.5473.2156.camel@vega.slimlogic.co.uk>
 <000601c9d7ac$58af73d0$0a0e5b70$%szyprowski@samsung.com>
 <1242647032.5473.2162.camel@vega.slimlogic.co.uk>
 <002c01c9d843$69b09b40$3d11d1c0$%szyprowski@samsung.com>
 <20090519095847.GE27195@sirena.org.uk>
 <1242730021.5473.2550.camel@vega.slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, May 19, 2009 12:47 PM Liam Girdwood wrote:

> On Tue, 2009-05-19 at 10:58 +0100, Mark Brown wrote:
> > On Tue, May 19, 2009 at 07:33:55AM +0200, Marek Szyprowski wrote:
> > > This patch adds regulator drivers for National Semiconductors
> LP3971 PMIC.
> > > This LP3971 PMIC controller has 3 DC/DC voltage converters and 5
> low
> > > drop-out
> > > (LDO) regulators. LP3971 PMIC controller uses I2C interface.
> >
> > > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >
> > > +static int lp3971_dcdc_list_voltage(struct regulator_dev *dev,
> unsigned
> > > index)
> >
> > I'm OK with this but it looks like your MUA has mangled the patch by
> > word wrapping so Liam may not be able to apply it.  There's some
> hints
> > on configuring various mail clients in Documentation/email-
> clients.txt
> > which might be helpful.
> >
> 
> I've now applied the patch after it was mangled by outlook.

Thanks for your patience.

> I have also fixed the following build error :-
> `lp3971_i2c_remove' referenced in section `.data' of drivers/built-
> in.o: defined in discarded section `.devexit.text' of drivers/built-
> in.o
> [...]
> Best to pull for-next to get this fix.

Thanks for your fix!

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


