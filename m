Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYHKXS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYHKXS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYHKXSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:18:15 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:37440 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbYHKXSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:18:15 -0400
Message-ID: <48A0C927.8020501@opengridcomputing.com>
Date: Mon, 11 Aug 2008 18:20:07 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rdreier@cisco.com, jgarzik@pobox.com, divy@chelsio.com, kxie@chelsio.com,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <adavdy9zc2k.fsf@cisco.com>	<20080809.224725.130946315.davem@davemloft.net>	<adabpzzzg81.fsf@cisco.com> <20080811.140918.213422266.davem@davemloft.net>
In-Reply-To: <20080811.140918.213422266.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Roland Dreier <rdreier@cisco.com>
> Date: Mon, 11 Aug 2008 09:09:02 -0700
>
>   
>>  > We turn it off.  If I want to shape or filter one of these iSCSI
>>  > connections can we turn it off?
>>
>> That seems like a reasonable idea to me -- the standard thing to do when
>> a NIC offload conflicts with something else is to turn off the offload
>> and fall back to software.
>>     
>
> But as Herbert says, we can make LRO such that turning it off
> isn't necessary.
>
> Can we shape the iSCSI offload traffic without turning it off?
>   

With Chelsio's product you can do this.  Maybe Divy can provide details?



