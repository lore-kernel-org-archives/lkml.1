Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbXGaOSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbXGaOSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761811AbXGaOSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:18:41 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:30850 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127AbXGaOSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:18:40 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: jack@hawkeye.stone.uk.eu.org
Subject: Re: [Patch 06/16] This removes unnecessary kmalloc casts and corrects a test for kmalloc failure.
Date: Tue, 31 Jul 2007 16:17:48 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Ronald Bultje <rbultje@ronald.bitfreak.net>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125440.794755000@hawkeye.stone.uk.eu.org>
In-Reply-To: <20070731125440.794755000@hawkeye.stone.uk.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311617.48755.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 31. Juli 2007 schrieb jack@hawkeye.stone.uk.eu.org:
> --- a/drivers/media/video/zoran_driver.c
> +++ b/drivers/media/video/zoran_driver.c
[...]
> -			mem =
> -			    (unsigned long) kmalloc(fh->jpg_buffers.
> -						    buffer_size,
> -						    GFP_KERNEL);
> +			mem = kmalloc(fh->jpg_buffers.buffer_size, GFP_KERNEL);
[...]

NAK. See the comments to the other patches. The cast is necessary.
