Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbZDCHEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbZDCHEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZDCHEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:04:15 -0400
Received: from smtp.nokia.com ([192.100.105.134]:53053 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbZDCHEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:04:14 -0400
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: david-b@pacbell.net, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <a95a62fe0904021641j17a7c26dv5652de4a19bad662@mail.gmail.com>
References: <200903260042.42091.david-b@pacbell.net>
	 <a95a62fe0904021641j17a7c26dv5652de4a19bad662@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Apr 2009 10:03:35 +0300
Message-Id: <1238742215.20906.99.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Apr 2009 07:03:37.0157 (UTC) FILETIME=[4F769F50:01C9B42A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 16:41 -0700, Kevin Cernekee wrote:
> Here is a follow-up patch to apply on top of David Brownell's original
> MTD driver model patch at:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2009-March/025005.html
> 
> Changes:
> 
> 1) Add more sysfs attributes: mtd_flags, mtd_size, mtd_erasesize,
> mtd_writesize, mtd_oobsize, mtd_numeraseregions, mtd_name .

Please, do not all the "mtd_" prefix to the file names. This is
redundant information because we already know this is about
mtd from the path.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

