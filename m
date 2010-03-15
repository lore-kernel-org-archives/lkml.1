Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab0COGuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 02:50:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38018 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab0COGuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 02:50:18 -0400
Date: Mon, 15 Mar 2010 07:48:31 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic
In-reply-to: <1268306294.3758.78.camel@odin>
To: "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "'Kyungmin Park'" <kyungmin.park@samsung.com>
Cc: "'axel lin'" <axel.lin@gmail.com>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Message-id: <000101cac40b$89137ac0$9b3a7040$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcrBDJsiF3v8euwqSrS4pnH/yybTxQC/m00Q
References: <427d64721003101756j2a5bf502na83ab35de4bc247e@mail.gmail.com>
 <20100311110438.GF2585@rakim.wolfsonmicro.main> <1268306294.3758.78.camel@odin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, March 11, 2010 12:18 PM Liam Girdwood wrote:

> On Thu, 2010-03-11 at 11:04 +0000, Mark Brown wrote:
> > On Thu, Mar 11, 2010 at 09:56:34AM +0800, axel lin wrote:
> > > From 99175ed0f281d54efdaf8eef548077a8f0b4924a Mon Sep 17 00:00:00 2001
> > > From: Axel Lin <axel.lin@gmail.com>
> > > Date: Thu, 11 Mar 2010 09:50:07 +0800
> > > Subject: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic
> > >
> > > Given x=0,1,2, current implementation of BUCK_VOL_CHANGE_SHIFT(x) returns 0,4,8.
> > > The correct return value should be 0,4,6.
> > > This patch fix the logic.
> > >
> > > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >
> > with the same comment about ideally wanting someone who worked on the
> > driver previously to check stuff.
> 
> Marek, Kyungmin, could someone please test/ack this before both are
> applied.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Axel was right, my bit arithmetic was definitely wrong. Again, thanks for spotting
it and I'm really sorry You had lost some time debugging it.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

