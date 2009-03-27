Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZC0Cjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZC0Cjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 22:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbZC0CjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 22:39:11 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:31268 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZC0CjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 22:39:10 -0400
Date: Thu, 26 Mar 2009 19:39:04 -0700
To: "David Miller" <davem@davemloft.net>
Subject: [PATCH 0/5 2.6.30] cxgb3: driver updates
From: "Divy Le Ray" <divy@chelsio.com>
Organization: Chelsio Communications
Cc: NetDev <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Steve Wise" <swise@opengridcomputing.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.urfizesdduofyu@speedy5>
User-Agent: Opera Mail/9.64 (Linux)
X-OriginalArrivalTime: 27 Mar 2009 02:40:01.0890 (UTC) FILETIME=[53F02420:01C9AE85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dave,

I'm submitting a series of patches, targeted for 2.6.30 if
the merge window is not closed.

Here is a brief description of the patches:
- start the SGE reclaim timers only when the sge is fully setup
- update SGE setup to avoid potential H/W issues
- use resource_size_t for the declaration of mmio related variables
- differentiate the adapter ports from the H/W Tx channels
- Reduce DMA mappings to entire pages on Rx to reduce iommu activity

Cheers,
Divy
