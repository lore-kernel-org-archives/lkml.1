Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbXK2S0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbXK2S0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758962AbXK2SZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:25:51 -0500
Received: from ns2.lanforge.com ([66.165.47.211]:55807 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbXK2SZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:25:50 -0500
Message-ID: <474F0422.6090309@candelatech.com>
Date: Thu, 29 Nov 2007 10:25:38 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: Jeff Garzik <jeff@garzik.org>, NetDev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] cxgb - driver fixes.
References: <474C8BF8.9080609@chelsio.com>
In-Reply-To: <474C8BF8.9080609@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> Jeff,
> 
> I'm submitting a patch series for inclusion in 2.6.24 for the cxgb driver.
> The patches are built against Linus'git tree.
> 
> Here is a brief description:
> - Ensure that GSO skbs have enough headroom before encapsulating them,
> - Fix a crash in NAPI mode,
> - Fix statistics accounting and report.

We ran pktgen overnight on 2.6.23 with patch 1 and 3 applied (patch 2
not needed on .23 it seems) and it was stable at about 1.5Gbps bi-directional
using 1500 MTU sized frames.

We'll run some more tests with user-space TCP & UDP today, but it looks good
so far.

Perhaps these patches should be considered for .23 stable as well?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

