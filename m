Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbXEYLYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbXEYLYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbXEYLXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:23:55 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46522 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXEYLXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:23:54 -0400
Date: Fri, 25 May 2007 13:24:14 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Geert.Uytterhoeven@sonycom.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Message-ID: <20070525112414.GA32336@aepfle.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070525083632.677742000@sonycom.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, Geert.Uytterhoeven@sonycom.com wrote:

> +++ b/drivers/scsi/ps3rom.c

> +			kaddr = kmap_atomic(sgpnt->page, KM_USER0);

linux/highmem.h is not included to get the kmap_* prototypes.
