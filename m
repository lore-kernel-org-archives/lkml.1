Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYIJSjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYIJSjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYIJSjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:39:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbYIJSje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:39:34 -0400
Subject: Re: [PATCH 2/2] regulator: Add WM8400 regulator support
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1221071334-19381-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20080910182825.GB16721@rakim.wolfsonmicro.main>
	 <1221071334-19381-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1221071334-19381-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 19:39:28 +0100
Message-Id: <1221071968.17091.245.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 19:28 +0100, Mark Brown wrote:
> The WM8400 provides two programmable DCDC step-down (buck) convertors
> and four low-dropout (LDO) regulators. This driver provides support for
> runtime managment of these in the standard regulator API.
> 
> Support for configuration of the suspend and hibernate mode behaviour
> of the regulators is not yet included.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

snip

> +
> +static unsigned int wm8400_dcdc_get_optimum_mode(struct regulator_dev *dev,
> +						 int input_uV, int output_uV,
> +						 int load_uA)
> +{
> +	return REGULATOR_MODE_IDLE;
> +}
> +

This should return NORMAL by default. Probably best to add a lookup
table for IDLE & STANDBY if supported.

Cheers

Liam

