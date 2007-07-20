Return-Path: <linux-kernel-owner+w=401wt.eu-S934378AbXGTH0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378AbXGTH0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759941AbXGTH0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:26:13 -0400
Received: from smtp.nokia.com ([131.228.20.172]:43465 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbXGTH0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:26:12 -0400
Subject: Re: [PATCH] UBI: potential leak in ubi_scan_erase_peb
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Florin Malita <fmalita@gmail.com>
Cc: linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <469FBA01.80107@gmail.com>
References: <469FBA01.80107@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 20 Jul 2007 10:25:57 +0300
Message-Id: <1184916357.25822.2.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Jul 2007 07:25:57.0371 (UTC) FILETIME=[36F0CCB0:01C7CA9F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 15:22 -0400, Florin Malita wrote:
> Coverity (1769) found the following problem: if the erase counter 
> overflow check triggers, ec_hdr is leaked.
> 
> Moving the allocation after the overflow check should take care of it.
> 
> Signed-off-by: Florin Malita <fmalita@gmail.com>

Committed, thank you!

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

