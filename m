Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZCCT7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZCCT7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZCCT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:59:11 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:27703 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbZCCT7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:59:11 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <49AD8C09.7070002@tremplin-utc.net>
Date: Tue, 03 Mar 2009 20:59:05 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 5/5] lis3: SPI transport layer
References: <49ABB22F.7040508@tremplin-utc.net> <1236004310-29196-1-git-send-email-daniel@caiaq.de> <1236004310-29196-2-git-send-email-daniel@caiaq.de> <1236004310-29196-3-git-send-email-daniel@caiaq.de> <1236004310-29196-4-git-send-email-daniel@caiaq.de> <1236004310-29196-5-git-send-email-daniel@caiaq.de>
In-Reply-To: <1236004310-29196-5-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack schreef:
> Make use of the new abstraction layer and add a new transport layer for
> spi. Works fine on a PXA based board.
> 
Hi,
Not much to say about this part. Just this minor comment:
:
> +
> +static int lis3_spi_init(struct lis3lv02d *lis3)
> +{
> +	u8 reg;
> +	int ret;
> +
> +	ret = lis3->read(lis3, CTRL_REG1, &reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	reg |= 0x40;
No magic please, use the constants defined in lis3lv02d.h : CTRL1_PD0.


> +	return lis3->write(lis3, CTRL_REG1, reg);
> +}

Looks good otherwise :-)
Eric
