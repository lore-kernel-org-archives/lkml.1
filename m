Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbXKLWzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbXKLWzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbXKLWzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:55:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:25782 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbXKLWy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:54:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,407,1188802800"; 
   d="scan'208";a="232718452"
Message-ID: <4738D9AB.8080408@intel.com>
Date: Mon, 12 Nov 2007 14:54:35 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: David Miller <davem@davemloft.net>, kaber@trash.net, joonwpark81@gmail.com,
       netdev@vger.kernel.org, djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous
 mode
References: <47365200.0f10240a.0686.2173@mx.google.com> <47388988.1000506@intel.com>	<47388B9F.7050308@trash.net> <20071112.143342.10809862.davem@davemloft.net> <4738D70C.4060404@nortel.com>
In-Reply-To: <4738D70C.4060404@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2007 22:54:58.0092 (UTC) FILETIME=[0C8116C0:01C8257F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> David Miller wrote:
> 
>> When you select VLAN, you by definition are asking for non-VLAN
>> traffic to be elided.  It is like plugging the ethernet cable
>> into one switch or another.
> 
> For max functionality it seems like the raw eth device should show
> everything on the wire in promiscuous mode.
> 
> If we want to sniff only the traffic for a specific vlan, we can sniff
> the vlan device.

actually the impact can be quite negative, imagine doing a tcpdump on a 10gig
interface with vlan's enabled - all of a sudden you might accidentally flood the
system with a 100-fold increase in traffic and force the stack to dump all those
packets for you.

I'm still very reluctant about this patch, I think the current situation is OK for
everyone and offers everyone the possibility to do what they need, without hidden
consequences.

Auke
