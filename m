Return-Path: <linux-kernel-owner+w=401wt.eu-S932179Ab0ASJ0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0ASJ0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962Ab0ASJ0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:26:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46319
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755495Ab0ASJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:26:18 -0500
Date: Tue, 19 Jan 2010 01:26:27 -0800 (PST)
Message-Id: <20100119.012627.220165105.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 33/64] cy82c693: fix PIO timings calculations
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118171847.14623.38391.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171847.14623.38391.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:18:47 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] cy82c693: fix PIO timings calculations
> 
> Just use the standard ide_timing_compute() helper to calculate
> PIO timings.  This fixes many issues with the open-coded version
> like using 16-bit timings when 8-bit ones should be used or not
> accounting for the enhanced cycle time specified by the device.
> 
> Based on libata pata_cypress host driver.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
