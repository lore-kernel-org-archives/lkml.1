Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYKQE5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYKQE5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 23:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYKQE5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 23:57:25 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:37666 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbYKQE5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 23:57:24 -0500
Message-ID: <4920F8C4.30209@linux.vnet.ibm.com>
Date: Mon, 17 Nov 2008 10:23:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Arjan van de Ven <arjan@infradead.org>, Dave Airlie <airlied@gmail.com>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
References: <491FA28B.2070003@cn.fujitsu.com>	<20081115205229.765f7ee3@infradead.org>	<20081116.001926.150424480.davem@davemloft.net>	<20081116105725.12458b13@infradead.org>	<21d7e9970811161339x174d6041x1622d478f8e4247e@mail.gmail.com> <20081116135130.5e8b4e13@infradead.org> <4920D238.8090905@cn.fujitsu.com>
In-Reply-To: <4920D238.8090905@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Arjan van de Ven wrote:
>> On Mon, 17 Nov 2008 07:39:55 +1000
>>
>> I would go further than this.
>>
>> Make the code just use vmalloc(). Period.
>>
>> But then make vmalloc() smart and try do a direct mapping allocation
>> first, before falling back to a virtual mapping. (and based on size it
>> wouldn't even try it for just big things)
>>
>>
>>
> 
> Hi, Arjan van de Ven
> 
> (I'll rename simple_malloc/simple_free to kvmalloc/kvfree)
> 

I would prefer to find a way to say that one cannot select gfp_mask with this API.

-- 
	Balbir
