Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZFOW3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZFOW3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZFOW3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:29:32 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:58133 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbZFOW3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:29:32 -0400
Message-ID: <4A36CB88.1080300@opengridcomputing.com>
Date: Mon, 15 Jun 2009 17:30:32 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jiri Kosina <trivial@kernel.org>, zygo.blaxell@xandros.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LIB: remove unmatched write_lock() in gen_pool_destroy
References: <E1MGFiZ-0006oN-UW@dactyl.ottawa.xandros.ca>	<alpine.LNX.2.00.0906152333080.7457@wotan.suse.de> <20090615152608.7f4f6548.akpm@linux-foundation.org>
In-Reply-To: <20090615152608.7f4f6548.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 15 Jun 2009 23:35:31 +0200 (CEST)
> Jiri Kosina <trivial@kernel.org> wrote:
>
>   
>>> -	write_lock(&pool->lock);
>>>  	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
>>>  		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
>>>  		list_del(&chunk->next_chunk);
>>> -- 
>>> 1.5.6.5
>>>
>>>       
>> Hi Zygo,
>>
>> this doesn't really qualify for trivial tree, as it introduces a 
>> significant code change. Adding some CCs.
>>     
>
> yep, I merged it, thanks.
>
> I wonder why drivers/infiniband/hw/cxgb3 users never noticed this.
>   

I seem to remember trying to get this removed a few years ago and the 
owner didn't want it removed...


