Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab0CKLSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:18:20 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37204 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab0CKLST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:18:19 -0500
Subject: Re: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Cc: axel lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20100311110438.GF2585@rakim.wolfsonmicro.main>
References: <427d64721003101756j2a5bf502na83ab35de4bc247e@mail.gmail.com>
	 <20100311110438.GF2585@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 11:18:14 +0000
Message-ID: <1268306294.3758.78.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 11:04 +0000, Mark Brown wrote:
> On Thu, Mar 11, 2010 at 09:56:34AM +0800, axel lin wrote:
> > From 99175ed0f281d54efdaf8eef548077a8f0b4924a Mon Sep 17 00:00:00 2001
> > From: Axel Lin <axel.lin@gmail.com>
> > Date: Thu, 11 Mar 2010 09:50:07 +0800
> > Subject: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic
> > 
> > Given x=0,1,2, current implementation of BUCK_VOL_CHANGE_SHIFT(x) returns 0,4,8.
> > The correct return value should be 0,4,6.
> > This patch fix the logic.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> with the same comment about ideally wanting someone who worked on the
> driver previously to check stuff.

Marek, Kyungmin, could someone please test/ack this before both are
applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

