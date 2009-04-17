Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbZDQH1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbZDQH1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbZDQH1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:27:03 -0400
Received: from smtp.nokia.com ([192.100.122.233]:24165 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZDQH1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:27:00 -0400
Subject: Re: [PATCH]fix a warning on drivers/mtd/nand/cafe_nand.c
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
       linux-mtd@lists.infradead.org
In-Reply-To: <20090410124243.GA9852@helight>
References: <20090410124243.GA9852@helight>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Apr 2009 10:26:40 +0300
Message-Id: <1239953200.3390.241.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Apr 2009 07:26:42.0522 (UTC) FILETIME=[DAFD0BA0:01C9BF2D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 20:42 +0800, Zhenwen Xu wrote:
> fix this warning:
> 
> drivers/mtd/nand/cafe_nand.c: In function ‘cafe_nand_probe’:
> drivers/mtd/nand/cafe_nand.c:730: warning: passing argument 2 of ‘request_irq’ from incompatible pointer type
> 
> 
> From 8f877dd15fedd434e2f5d95a1bc5f4e528dc4528 Mon Sep 17 00:00:00 2001
> From: Zhenwen Xu <Helight.Xu@gmail.com>
> Date: Fri, 10 Apr 2009 20:35:30 +0800
> Subject: [PATCH] fix a warning on drivers/mtd/nand/cafe_nand.c
> 
> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> ---
>  drivers/mtd/nand/cafe_nand.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pushed, to l2-mtd-2.6.git. This does not guarantee anything,
it just mean I'll ping dwmw2 to pull from that tree.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

