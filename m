Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbXKLSCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbXKLSCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXKLSCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:02:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:43018 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754514AbXKLSCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:02:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,406,1188802800"; 
   d="scan'208";a="268859166"
Message-ID: <4738950D.7070902@intel.com>
Date: Mon, 12 Nov 2007 10:01:49 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       "'Dave Johnson'" <djohnson+linux-kernel@sw.starentnetworks.com>,
       linux-kernel@vger.kernel.org, Joonwoo Park <joonwpark81@gmail.com>,
       "'David Miller'" <davem@davemloft.net>
Subject: Re: [E1000-devel] [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel
 when promiscuous mode
References: <47365200.0f10240a.0686.2173@mx.google.com>	<47388988.1000506@intel.com> <47388B9F.7050308@trash.net>
In-Reply-To: <47388B9F.7050308@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2007 18:02:17.0620 (UTC) FILETIME=[29A5B540:01C82556]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Kok, Auke wrote:
>> Joonwoo Park wrote:
>>> IMHO even though netdevice is in the promiscuous mode, we should receive all of ingress packets.
>>> This disable the vlan filtering feature when a vlan hw accel configured e1000 device goes into promiscuous mode.
>>> This make packets visible to sniffers though it's not vlan id of itself.
>>> Any check, comments will be appreciated.
>> Actually I think this patch removes a choice from the user.
>>
>> Before this patch, the user can sniff all traffic by disabling vlans, or a
>> specific vlan only by leaving vlans on when going into promisc mode.
>>
>> After this patch, the user has no choice but to sniff all vlans at all times.
>>
>> I don't think that that is such a good improvement.
> 
> 
> Do you really consider that a realistic choice? Who is going to
> remove interfaces that are in use just to see traffic for other
> VLANs? Sniffing specific VLANs can always be done on the VLAN
> device itself.

right, I had not thought of that.

> IMO its more a question of what we want promiscous mode to mean,
> and I tend to agree with Joonwoo that it should receive all packets.

OK, Joonwoo: can you submit a patch against e1000e as well?

Auke
