Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZKBXsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZKBXsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZKBXsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:48:31 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50975 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbZKBXsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:48:31 -0500
Message-ID: <4AEF6FC4.6060208@cs.wisc.edu>
Date: Mon, 02 Nov 2009 17:48:20 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rakesh Ranjan <rakesh@chelsio.com>
CC: davem@davemloft.net, James Bottomley <James.Bottomley@suse.de>,
       Karen Xie <kxie@chelsio.com>,
       "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [RFC-PATCH] dhcp provisioning support in cxgb3i
References: <4AE995C4.4080909@chelsio.com> <4AEA04A4.1060800@cs.wisc.edu> <4AEA7870.4010804@chelsio.com>
In-Reply-To: <4AEA7870.4010804@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakesh Ranjan wrote:
> Mike Christie wrote:
>> Rakesh Ranjan wrote:
>>> Hi Mike,
>>>
>>> Herein attached patches for having dhcp provisioning support in 
>>> cxgb3i. I have added one new iscsi netlink message 
>>> ISCSI_UEVENT_REQ_IPCONF. 
>>
>> Is the idea to have iscsid/uip send down this msg?
>>
>> Was it not possible to hook in more like how bnx2i does dhcp?
> 
> yep, idea is to have iscsid send down ISCSI_UEVENT_REQ_IPCONF msg. bnx2i 
> approach in our case for at least T3 is not feasible.
> 

I think adding DHCP in the kernel is getting a little crazy :) If we go 
down this path, I agree with the other person that stated it should at 
least be generic.
