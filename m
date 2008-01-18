Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYARLLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYARLLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYARLLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:11:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45217 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbYARLLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:11:32 -0500
Date: Fri, 18 Jan 2008 20:11:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] a bit improvement of ZONE_DMA page reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Rik van Riel <riel@redhat.com>, Daniel Spang <daniel.spang@gmail.com>
In-Reply-To: <20080118162434.8FB1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080117232147.85ae8cab.akpm@linux-foundation.org> <20080118162434.8FB1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080118200423.8FBC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> > > on X86, ZONE_DMA is very very small.
> > > It is often no used at all. 
> > 
> > In that case page-reclaim is supposed to set all_unreclaimable and
> > basically ignores the zone altogether until it looks like something might
> > have changed.
> > 
> > Is that code not working?  (quite possible).
> 
> please insert blow debug printk and dd if=bigfile of=/dev/null.
> you see "near_oom(DMA) 0 0 0" messages :)

sorry, my last mail is not enough description.
It is not so useful at solo use. 
As you say, If long time passes all_unreclaimable turn on and 
incorrect shrink list become no happned.

but, my mem_notify patch very dislike incorrect shrink ;-)

result as, I don't hope quick merge.
and I will merge to my mem_notify patch series.

Thanks.


- kosaki


