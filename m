Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0BLLcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:32:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43006 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755168Ab0BLLcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:32:53 -0500
Date: Fri, 12 Feb 2010 11:32:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator/lp3971: vol_map out of bounds in
 lp3971_{ldo,dcdc}_set_voltage()
Message-ID: <20100212113250.GA19122@rakim.wolfsonmicro.main>
References: <4B753BCD.8060100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B753BCD.8060100@gmail.com>
X-Cookie: Inspired by a true story.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 12:30:21PM +0100, Roel Kluin wrote:
> After `for (val = LDO_VOL_MIN_IDX; val <= LDO_VOL_MAX_IDX; val++)', if no break
> occurs, val reaches LDO_VOL_MIN_IDX + 1, which is out of bounds for
> ldo45_voltage_map[] and ldo123_voltage_map[].
> 
> Similarly BUCK_TARGET_VOL_MAX_IDX + 1 is out of bounds for buck_voltage_map[].

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
