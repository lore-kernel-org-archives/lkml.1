Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbYBLHri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbYBLHri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbYBLHr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:47:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:33284 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbYBLHr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:47:28 -0500
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] mlx4: fix build break
Date: Tue, 12 Feb 2008 09:43:33 +0200
User-Agent: KMail/1.9.1
Cc: Olof Johansson <olof@lixom.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, tziporet@mellanox.co.il
References: <adafxw36ntm.fsf@cisco.com> <20080211022257.GA26656@lixom.net> <adaodanxhlb.fsf@cisco.com>
In-Reply-To: <adaodanxhlb.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120943.34388.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008 00:18, Roland Dreier wrote:
> Thanks, applied.
> 
> Jack, I thought you guys tested the build on powerpc.  How did this
> sneak through?
> 
It did not sneak through, because the problem does not exist in the OFED git.

The following commit was performed to
 git://git.openfabrics.org/ofed_1_3/linux-2.6.git
on Sept 25, 2007:
=======================================
commit 4a5709b81dfd249c98271801ddc01decb7acd466
Author: Eli Cohen <eli@mellanox.co.il>
Date:   Tue Sep 25 12:41:30 2007 +0200

    add missing include file. ia64 requires it.

    Signed-off-by: Eli Cohen <eli@mellanox.co.il>

diff --git a/drivers/net/mlx4/alloc.c b/drivers/net/mlx4/alloc.c
index f8d63d3..704a56b 100644
--- a/drivers/net/mlx4/alloc.c
+++ b/drivers/net/mlx4/alloc.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/bitmap.h>
 #include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>

 #include "mlx4.h"
========================================

I guess this just fell through the cracks with regard to posting it to the list.
Sorry about that.

- Jack
