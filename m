Return-Path: <linux-kernel-owner+w=401wt.eu-S1765183AbZE2U3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765183AbZE2U3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbZE2U2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:28:07 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:16438 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbZE2U2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:28:05 -0400
Message-ID: <4A204554.8070808@chelsio.com>
Date: Fri, 29 May 2009 13:28:04 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH net-next 1/2] cxgb3: move away from LLTX
References: <20090529075823.30669.28885.stgit@speedy5> <20090529.015747.109057209.davem@davemloft.net>
In-Reply-To: <20090529.015747.109057209.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2009 20:29:22.0281 (UTC) FILETIME=[26891D90:01C9E09C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Divy Le Ray <divy@chelsio.com>
> Date: Fri, 29 May 2009 00:58:24 -0700
>
>   
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> cxgb3 no longer advertizes LLTX.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>>     
>
> You might want to mention that these two patches depend
> upon the 2.6.30 cxgb3 patches you also submitted at this
> time and aren't in the tree yet. :-/
>   

Sorry about that. It actually conflicts with Eric Dumazet's trans_start 
removal patch.
I'll resubmit the net-next patches, refreshed on op of Eric's patch.
I also verified that the 2.6.30 cxgb3 patches apply
before or after the cxgb3 net-next series is applied.

Cheers,
Divy
