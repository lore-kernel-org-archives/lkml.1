Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYKQF0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYKQF0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 00:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYKQF0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 00:26:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53957 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYKQF0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 00:26:22 -0500
Date: Mon, 17 Nov 2008 14:25:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Arjan van de Ven <arjan@infradead.org>, Dave Airlie <airlied@gmail.com>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       menage@google.com, jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Message-Id: <20081117142539.9b2c6bfc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4920F8C4.30209@linux.vnet.ibm.com>
References: <491FA28B.2070003@cn.fujitsu.com>
	<20081115205229.765f7ee3@infradead.org>
	<20081116.001926.150424480.davem@davemloft.net>
	<20081116105725.12458b13@infradead.org>
	<21d7e9970811161339x174d6041x1622d478f8e4247e@mail.gmail.com>
	<20081116135130.5e8b4e13@infradead.org>
	<4920D238.8090905@cn.fujitsu.com>
	<4920F8C4.30209@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 10:23:24 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Lai Jiangshan wrote:
> > Arjan van de Ven wrote:
> >> On Mon, 17 Nov 2008 07:39:55 +1000
> >>
> >> I would go further than this.
> >>
> >> Make the code just use vmalloc(). Period.
> >>
> >> But then make vmalloc() smart and try do a direct mapping allocation
> >> first, before falling back to a virtual mapping. (and based on size it
> >> wouldn't even try it for just big things)
> >>
> >>
> >>
> > 
> > Hi, Arjan van de Ven
> > 
> > (I'll rename simple_malloc/simple_free to kvmalloc/kvfree)
> > 
> 
> I would prefer to find a way to say that one cannot select gfp_mask with this API.
> 
I think gfp_mask must be passed explicitly.

Thanks,
-Kame

