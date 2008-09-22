Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbYIVIbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbYIVIbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYIVIa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:30:59 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:44250 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbYIVIa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:30:58 -0400
Date: Mon, 22 Sep 2008 10:30:34 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <ukleinek@strlen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use platform_driver_probe for pdc platform driver
Message-ID: <20080922103034.07e2d6cd@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1222033928-25062-2-git-send-email-ukleinek@strlen.de>
References: <1222033928-25062-1-git-send-email-ukleinek@strlen.de>
	<1222033928-25062-2-git-send-email-ukleinek@strlen.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Sep 2008 08:30:23.0305 (UTC) FILETIME=[74D80390:01C91C8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <ukleinek@strlen.de> wrote:
> The probe function of the pdc platform driver lives in the init section
> and so a pdc device that is created after the init section is discarded
> probably results in an oops.  Even if this cannot happen, using
> platform_driver_probe is cleaner.  (If this can happen and should be
> supported the probe function must live in the devinit section instead.)
> 
> Signed-off-by: Uwe Kleine-KÃ¶nig <ukleinek@strlen.de>
> Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Applied both this and the pio one. Thanks!

Haavard
