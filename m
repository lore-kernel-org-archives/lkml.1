Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZJ3FYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZJ3FYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 01:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZJ3FYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 01:24:16 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:18081 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbZJ3FYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 01:24:15 -0400
Message-ID: <4AEA7870.4010804@chelsio.com>
Date: Fri, 30 Oct 2009 10:54:00 +0530
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
       netdev@vger.kernel.org
Subject: Re: [RFC-PATCH] dhcp provisioning support in cxgb3i
References: <4AE995C4.4080909@chelsio.com> <4AEA04A4.1060800@cs.wisc.edu>
In-Reply-To: <4AEA04A4.1060800@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2009 05:26:10.0890 (UTC) FILETIME=[7D9092A0:01CA5921]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Christie wrote:
> Rakesh Ranjan wrote:
>> Hi Mike,
>>
>> Herein attached patches for having dhcp provisioning support in 
>> cxgb3i. I have added one new iscsi netlink message 
>> ISCSI_UEVENT_REQ_IPCONF. 
> 
> Is the idea to have iscsid/uip send down this msg?
> 
> Was it not possible to hook in more like how bnx2i does dhcp?

yep, idea is to have iscsid send down ISCSI_UEVENT_REQ_IPCONF msg. bnx2i 
approach in our case for at least T3 is not feasible.

Regards
Rakesh Ranjan
