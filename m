Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZCFHha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZCFHha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZCFHhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:37:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33487 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZCFHhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:37:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
Cc: kosaki.motohiro@jp.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090306072328.GL22605@hack.private>
References: <49B0CAEC.80801@cn.fujitsu.com> <20090306072328.GL22605@hack.private>
Message-Id: <20090306163600.3469.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri,  6 Mar 2009 16:37:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > /**
> >+ * kmemdup_from_user - duplicate memory region from user space
> >+ *
> >+ * @src: source address in user space
> >+ * @len: number of bytes to copy
> >+ * @gfp: GFP mask to use
> >+ */
> >+void *kmemdup_from_user(const void __user *src, size_t len, gfp_t gfp)
> >+{
> >+	void *p;
> >+
> >+	p = kmalloc_track_caller(len, gfp);
> 
> 
> Well, you use kmalloc_track_caller, instead of kmalloc as you showed
> above. :) Why don't you mention this?

kmalloc() wrapper function must use kmalloc_track_caller().
his code is right.

if not, kmalloc tracking feature is breaked.



