Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954Ab0ASJ0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0ASJ0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922Ab0ASJ0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:26:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46307
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911Ab0ASJZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:25:52 -0500
Date: Tue, 19 Jan 2010 01:26:02 -0800 (PST)
Message-Id: <20100119.012602.119364853.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/64] cmd64x: fix PIO and MWDMA timings calculations
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118171826.14623.15282.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171826.14623.15282.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:18:26 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] cmd64x: fix PIO and MWDMA timings calculations
> 
> Just use the standard ide_timing_compute() helper to calculate
> PIO and MWDMA timings.  This fixes some issues with the open-coded
> version like allowing faster MWDMA timings than the ones required
> by the current PIO mode or not accounting for the enhanced MWDMA
> cycle time specified by the device.
> 
> Based on libata pata_cmd64x host driver.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
