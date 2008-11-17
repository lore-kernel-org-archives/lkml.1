Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYKQHQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYKQHQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYKQHP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:15:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36489
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbYKQHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:15:56 -0500
Date: Sun, 16 Nov 2008 23:15:55 -0800 (PST)
Message-Id: <20081116.231555.190117597.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       balbir@linux.vnet.ibm.com, laijs@cn.fujitsu.com, arjan@infradead.org,
       airlied@gmail.com, menage@google.com, jens.axboe@oracle.com,
       jack@suse.cz, jes@sgi.com, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, adobriyan@gmail.com
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081116231301.c6b0da95.akpm@linux-foundation.org>
References: <20081117142539.9b2c6bfc.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0811162243r7527d271ya8ab2fc3a9be9f7d@mail.gmail.com>
	<20081116231301.c6b0da95.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 16 Nov 2008 23:13:01 -0800

> In fact it's not immediately clear why __vmalloc() takes a gfp_t
> argument either?

Probably for things like GFP_DMA32, GFP_HIGHMEM, et al.

