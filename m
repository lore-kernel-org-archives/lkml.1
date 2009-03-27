Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZC0Hzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZC0Hzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbZC0Hx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:53:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36378
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756321AbZC0Hxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:53:55 -0400
Date: Fri, 27 Mar 2009 00:53:42 -0700 (PDT)
Message-Id: <20090327.005342.73932167.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 5/5] cxgb3: map entire Rx page, feed map+offset
 to Rx ring.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090327023929.32137.65704.stgit@speedy5>
References: <20090327023909.32137.93884.stgit@speedy5>
	<20090327023929.32137.65704.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Thu, 26 Mar 2009 19:39:29 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> DMA mapping can be expensive in the presence of iommus.
> Reduce the Rx iommu activity by mapping an entire page, and provide the H/W
> the mapped address + offset of the current page chunk.
> Reserve bits at the end of the page to track mapping references, so the page
> can be unmapped.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
