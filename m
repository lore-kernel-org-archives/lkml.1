Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZBKIW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZBKIW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZBKIWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:22:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38946 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZBKIWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:22:50 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] vmalloc: Add __get_vm_area_caller()
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management <linux-mm@kvack.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090211044854.969CEDDDA9@ozlabs.org>
References: <20090211044854.969CEDDDA9@ozlabs.org>
Message-Id: <20090211171804.7021.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 11 Feb 2009 17:22:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have get_vm_area_caller() and __get_vm_area() but not __get_vm_area_caller()
> 
> On powerpc, I use __get_vm_area() to separate the ranges of addresses given
> to vmalloc vs. ioremap (various good reasons for that) so in order to be
> able to implement the new caller tracking in /proc/vmallocinfo, I need
> a "_caller" variant of it.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

It seems reasonable reason and this patch looks good to me :)
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> I want to put into powerpc-next patches relying into that, so if the
> patch is ok with you guys, can I stick it in powerpc.git ?

hm.
Generally, all MM patch should merge into -mm tree at first.
but I don't think this patch have conflict risk. 

Andrew, What do you think?




