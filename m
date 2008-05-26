Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbYEZElo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbYEZElo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 00:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYEZElg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 00:41:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59889 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYEZElg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 00:41:36 -0400
Date: Mon, 26 May 2008 13:40:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 2/3] slub: record page flag overlays explicitly
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1211560402.0@pinky>
References: <exportbomb.1211560342@pinky> <1211560402.0@pinky>
Message-Id: <20080526133755.4664.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch works well on my box.
but I have one question.

>  	if (s->flags & DEBUG_DEFAULT_FLAGS) {
> -		if (!SlabDebug(page))
> -			printk(KERN_ERR "SLUB %s: SlabDebug not set "
> +		if (!PageSlubDebug(page))
> +			printk(KERN_ERR "SLUB %s: SlubDebug not set "
>  				"on slab 0x%p\n", s->name, page);
>  	} else {
> -		if (SlabDebug(page))
> -			printk(KERN_ERR "SLUB %s: SlabDebug set on "
> +		if (PageSlubDebug(page))
> +			printk(KERN_ERR "SLUB %s: SlubDebug set on "
>  				"slab 0x%p\n", s->name, page);
>  	}
>  }

Why if(SLABDEBUG) check is unnecessary?



