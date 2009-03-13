Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZCMHOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZCMHOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZCMHNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:13:45 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:27577 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZCMHNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:13:44 -0400
Message-ID: <49BA07B4.30706@chelsio.com>
Date: Fri, 13 Mar 2009 00:13:56 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
       Linux Network Development list <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH net-next 0/10] cxgb3: driver updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Mar 2009 07:14:30.0015 (UTC) FILETIME=[59EC18F0:01C9A3AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I’m submitting 10 patches targeted for net-next-2.6.

Here is a brief description of the patch series:
- ring receive rings door bells less aggressively
- drop page reference when dma mapping fails
- fix skb truesize when coalescing fragments of a jumbo frame
- eliminate a cache miss in the GRO section of the driver
- segregate Rx and Tx credit reclaim timers
- poll for HW alert status when intrs would happen too frequently
- update the xgmac hang workaround for the chip's rev 3
- detect mac link faults
- update the FW rev to 7.1
- update the driver rev to 1.1.2

Cheers,
Divy
