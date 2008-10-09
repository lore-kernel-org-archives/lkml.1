Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbYJIR6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbYJIR6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbYJIR6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:58:18 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:31671 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760089AbYJIR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:58:16 -0400
Message-ID: <48EE4622.4080207@chelsio.com>
Date: Thu, 09 Oct 2008 10:57:54 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH 2/8 2.6.28] cxgb3 - Allocate multiqueues at init time
References: <20081009003402.13315.18192.stgit@speedy5> <20081008.174202.160320028.davem@davemloft.net>
In-Reply-To: <20081008.174202.160320028.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2008 17:57:49.0703 (UTC) FILETIME=[8B19D170:01C92A38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Divy Le Ray <divy@chelsio.com>
> Date: Wed, 08 Oct 2008 17:34:02 -0700
>
>   
>> Allocate a queue set per core, up to the maximum of available qsets.
>> Share the queue sets on multi port adapters.
>> Rename MSI-X interrupt vectors ethX-N, N being the queue set number.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>>     
>
> Applied, but...
>
> This "num processors" logic and policy belongs in some generic place.
> Perhaps "num_possible_cpus()" is more appropriate, who knows right?
>   

I'll look into it.

Cheers,
Divy

