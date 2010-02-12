Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0BLLn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:43:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:35758 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab0BLLnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:43:15 -0500
Subject: Re: [PATCH] regulator/lp3971: vol_map out of bounds in
 lp3971_{ldo,dcdc}_set_voltage()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B753BCD.8060100@gmail.com>
References: <4B753BCD.8060100@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 11:43:10 +0000
Message-ID: <1265974990.3231.6.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 12:30 +0100, Roel Kluin wrote:
> After `for (val = LDO_VOL_MIN_IDX; val <= LDO_VOL_MAX_IDX; val++)', if no break
> occurs, val reaches LDO_VOL_MIN_IDX + 1, which is out of bounds for
> ldo45_voltage_map[] and ldo123_voltage_map[].
> 
> Similarly BUCK_TARGET_VOL_MAX_IDX + 1 is out of bounds for buck_voltage_map[].
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

