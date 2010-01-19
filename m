Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870Ab0ASJZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab0ASJZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726Ab0ASJZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:25:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46291
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818Ab0ASJZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:25:25 -0500
Date: Tue, 19 Jan 2010 01:25:35 -0800 (PST)
Message-Id: <20100119.012535.241986281.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/64] alim15x3: fix PIO timings calculations
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118171737.14623.10091.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171737.14623.10091.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:17:37 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] alim15x3: fix PIO timings calculations
> 
> Just use the standard ide_timing_compute() helper to calculate
> PIO timings.  This fixes many issues with the open-coded version
> like potential recovery timings underclocking or not accounting
> for the enhanced cycle time specified by the device.
> 
> Based on libata pata_ali host driver.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
