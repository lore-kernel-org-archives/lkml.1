Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbZF0LiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbZF0LiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZF0Lho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:37:44 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18813 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbZF0Lhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:37:40 -0400
Subject: Re: [PATCH] UBIFS: Fix integer overflow warnings
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <3f15c0091535d0ab4a1d45cbc9eb3667@localhost>
References: <3f15c0091535d0ab4a1d45cbc9eb3667@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Jun 2009 14:37:09 +0300
Message-Id: <1246102629.9487.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jun 2009 11:37:14.0527 (UTC) FILETIME=[9E173AF0:01C9F71B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 17:10 -0700, Kevin Cernekee wrote:
> This warning was observed on MIPS32 using 2.6.31-rc1 and gcc-4.2.0:
> 
> fs/ubifs/io.c: In function 'ubifs_wbuf_init':
> fs/ubifs/io.c:860: warning: integer overflow in expression
> fs/ubifs/io.c:860: warning: integer overflow in expression
> fs/ubifs/io.c:860: warning: integer overflow in expression
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Thanks for the patch,

however we there is already a fix for this. I'll send it to
Linus soon.

http://git.infradead.org/ubifs-2.6.git?a=commit;h=4804e8b700504978eb4b9397f818ba7ba1227a15

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

