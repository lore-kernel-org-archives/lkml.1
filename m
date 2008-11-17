Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYKQP2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYKQP2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYKQP23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:28:29 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:49321 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYKQP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:28:28 -0500
Date: Mon, 17 Nov 2008 16:25:06 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Add WM8350 LED driver
Message-ID: <20081117152506.GA29949@gambetta>
References: <1226933529-13070-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226933529-13070-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On Mon, Nov 17, 2008 at 02:52:09PM +0000, Mark Brown wrote:
[...]
> +/* Microamps */
> +static const int isink_cur[] = {
[...]
> +	223191
> +};
> +
[...]
> +	for (i = 0; i < ARRAY_SIZE(isink_cur); i++)
> +		if (isink_cur[i] >= pdata->max_uA)
> +			break;
> +	led->max_uA_index = i;
> +	if (pdata->max_uA != isink_cur[i])
                                      ^^^
I may be missing something but isn't the code doing an off-by-one here
if pdata->max_uA > 223191 ?

Regards,
Frederik
