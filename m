Return-Path: <linux-kernel-owner+w=401wt.eu-S936613AbZAPTG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936613AbZAPTG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbZAPTGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:06:09 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:24217 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbZAPTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:06:07 -0500
Message-ID: <4970DA8E.6030105@chelsio.com>
Date: Fri, 16 Jan 2009 11:05:50 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>,
       Casey Leedom <leedom@chelsio.com>
Subject: Re: [PATCH 2.6.28] cxgb3 - Fix LRO misalignment
References: <20090116004829.7437.52798.stgit@speedy5> <496FE973.1060106@hp.com>
In-Reply-To: <496FE973.1060106@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 19:06:21.0281 (UTC) FILETIME=[84B01510:01C9780D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
> Divy Le Ray wrote:
>   
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> The lro manager's frag_align_pad setting was missing,
>> leading to misaligned access to the skb passed up
>> to the stack.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>>     
>
> I have tried this in a tree I have, and where I was once seeing unaligned access 
> messages on an ia64 system with LRO enabled, now I see none.
>
> Tested-by: Rick Jones <rick.jones2@hp.com>
>
> rick jones
>
>   
Hi Dave,

The patch is intended for 2.6.29, not 2.6.28 as the subject mistakenly 
states.

Cheers,
Divy
