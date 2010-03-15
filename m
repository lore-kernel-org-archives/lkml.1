Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab0COGqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 02:46:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37059 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab0COGql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 02:46:41 -0400
Date: Mon, 15 Mar 2010 07:44:53 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] Regulators: lp3971 - Fix setting val for LDO2 and LDO4
In-reply-to: <20100310170717.GC22626@rakim.wolfsonmicro.main>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
       "'axel lin'" <axel.lin@gmail.com>
Cc: "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'Kyungmin Park'" <kyungmin.park@samsung.com>, lrg@slimlogic.co.uk
Message-id: <000001cac40b$07368ba0$15a3a2e0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcrAdCacLsv9QBKuQCuSKgbRgO30SADln1Qg
References: <427d64721003091629s4c5728b4y9005feeef9a05b7e@mail.gmail.com>
 <20100310170717.GC22626@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, March 10, 2010 6:07 PM Mark Brown wrote:

> On Wed, Mar 10, 2010 at 08:29:40AM +0800, axel lin wrote:
> > From: Axel Lin <axel.lin@gmail.com>
> > Date: Tue, 9 Mar 2010 16:53:59 +0800
> > Subject: [PATCH] lp3971: Fix setting val for LDO2 and LDO4
> >
> > In lp3971_ldo_set_voltage function, it requires val to left shift 4
> > bits for LDO2 and LDO4.
> > This patch fix this issue.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> but I really would prefer to see one of the Samsung folks comment.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

This was definitely a bug. Thanks for spotting it.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

