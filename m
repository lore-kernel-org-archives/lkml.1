Return-Path: <linux-kernel-owner+w=401wt.eu-S1757704AbZKDSYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbZKDSYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZKDSYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:24:21 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:30722 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZKDSYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:24:20 -0500
Message-ID: <4AF1C6C7.80103@chelsio.com>
Date: Wed, 04 Nov 2009 23:54:07 +0530
From: Rakesh Ranjan <rakesh@chelsio.com>
Organization: Chelsio Communications
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: davem@davemloft.net, James Bottomley <James.Bottomley@suse.de>,
       Karen Xie <kxie@chelsio.com>,
       "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       netdev@vger.kernel.org, Rakesh Ranjan <rakesh@chelsio.com>
Subject: Re: [RFC-PATCH] dhcp provisioning support in cxgb3i
References: <4AE995C4.4080909@chelsio.com> <4AEA04A4.1060800@cs.wisc.edu> <4AEA7870.4010804@chelsio.com> <4AEF6FC4.6060208@cs.wisc.edu>
In-Reply-To: <4AEF6FC4.6060208@cs.wisc.edu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2009 18:26:20.0109 (UTC) FILETIME=[4E194FD0:01CA5D7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Christie wrote:
> Rakesh Ranjan wrote:
>> Mike Christie wrote:
>>> Rakesh Ranjan wrote:
>>>> Hi Mike,
>>>>
>>>> Herein attached patches for having dhcp provisioning support in
>>>> cxgb3i. I have added one new iscsi netlink message
>>>> ISCSI_UEVENT_REQ_IPCONF. 
>>>
>>> Is the idea to have iscsid/uip send down this msg?
>>>
>>> Was it not possible to hook in more like how bnx2i does dhcp?
>>
>> yep, idea is to have iscsid send down ISCSI_UEVENT_REQ_IPCONF msg.
>> bnx2i approach in our case for at least T3 is not feasible.
>>
> 
> I think adding DHCP in the kernel is getting a little crazy :) If we go
> down this path, I agree with the other person that stated it should at
> least be generic.

Hi Mike,

What do you mean be generic ? Do you want to have a generic interface
for DHCP handler that could be part of libiscsi and could be used by
other LLD's.

Regards
Rakesh Ranjan
