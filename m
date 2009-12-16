Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbZLPFyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbZLPFyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760279AbZLPFyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:54:10 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:20620 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754379AbZLPFyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:54:08 -0500
Message-ID: <4B2875F8.4080107@voltaire.com>
Date: Wed, 16 Dec 2009 07:54:00 +0200
From: Or Gerlitz <ogerlitz@voltaire.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Eli Cohen <eli@dev.mellanox.co.il>
CC: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
References: <adaocm1csgb.fsf@roland-alpha.cisco.com> <20091215083458.GC10744@mtls03>
In-Reply-To: <20091215083458.GC10744@mtls03>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2009 05:54:00.0439 (UTC) FILETIME=[2A1BC870:01CA7E14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eli Cohen wrote:
>>  - IBoE.  In principle I think this is starting to get there.  Still
>>    want to see better ABI compatibility at least, and also make sure
>>    the interface chosen works for both rdmacm and non-rdmacm applications.
>>     
>> Based on this, I am going to send a new patch set, a few days after 2.6.33-rc1 is out
Eli, here are some more issues which should be on the table and you 
might want to look at before posting a new version of the patches (or 
else if you want to handle them down the road of the review process 
that's fine)

- loopback support , Liran commented that this works, does this mean 
only firmware fix is needed?

- below-the-cover-addr-resolve-in-create-AH flow races e.g 
https://bugs.openfabrics.org/show_bug.cgi?id=1866

- L2 Ethernet integration for rdma-cm based apps, namely at minimum have 
the <src/dst (unicast) mac, vlan ID, vlan Priority, mtu> gang to comply 
with packets sent by the network stack for the same IP route.

Or.
