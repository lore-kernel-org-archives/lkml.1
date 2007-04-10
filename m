Return-Path: <linux-kernel-owner+w=401wt.eu-S966017AbXDJA2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966017AbXDJA2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966001AbXDJA2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:28:32 -0400
Received: from stinky.trash.net ([213.144.137.162]:47474 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbXDJA2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:28:30 -0400
Message-ID: <461ADA18.8010206@trash.net>
Date: Tue, 10 Apr 2007 02:28:08 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, cramerj@intel.com, auke-jan.h.kok@intel.com,
       christopher.leech@intel.com
Subject: Re: [PATCH] NET: [UPDATED] Multiqueue network device support implementation.
References: <20070410003243.32106.98266.stgit@gitlost.site>
In-Reply-To: <20070410003243.32106.98266.stgit@gitlost.site>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter P Waskiewicz Jr wrote:
> From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> 
> Update: Fixed a typecast in free_netdev() for the egress_subqueue list.
> 
> Added an API and associated supporting routines for multiqueue network devices.
> This allows network devices supporting multiple TX queues to configure each
> queue within the netdevice and manage each queue independantly.  Changes to the
> PRIO Qdisc also allow a user to map multiple flows to individual TX queues,
> taking advantage of each queue on the device.


This indeed looks a lot better than the first patch. I'm too tired to
fully review this now, but could you please post the corresponding e1000
patch? From a quick look I'm guessing that this patch changes the
behaviour of the prio qdisc from strict priority to whatever scheduling
mechanism e1000 uses for its queues when the multiqueue config option
is enabled, which might surprise people.

