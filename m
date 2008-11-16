Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYKPFQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYKPFQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 00:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYKPFQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 00:16:39 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:33642 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYKPFQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 00:16:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kq80f/KzHLlxRjrM38lvVhLNzoQtiCAI/BUdKOZp13CKEBZ/+7XlSGEJECgFqNm1oD
         sLvI8K4nJMAiAWkGyKmjPZSHk5322qZ5XvkidnWNSvNwQCExlV/dGKsp93jMdFEo9xZk
         v6VfLlbZ2p7FxCNEJpg2sLETf6/5eKK5tv1Ng=
Message-ID: <491FACC3.1050202@gmail.com>
Date: Sun, 16 Nov 2008 14:16:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
References: <20081115112751.1d38c072@infradead.org>	<Pine.LNX.4.64.0811152003360.1618@blonde.site> <20081115123916.0d83a89e@infradead.org>
In-Reply-To: <20081115123916.0d83a89e@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> From 979d181d6199f639ba78c5eadf85857f6a9f3f89 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sat, 15 Nov 2008 11:23:58 -0800
> Subject: [PATCH] Fix kunmap() argument in sg_miter_stop
> 
> kunmap() takes as argument the struct page that orginally got kmap()'d,
> however the sg_miter_stop() function passed it the kernel virtual address
> instead, resulting in weird stuff.
> 
> Somehow I ended up fixing this bug by accident while looking for a bug
> in the same area.
> 
> Reported-by: kerneloops.org
> CC: htejun@gmail.com
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Argh... talk about confusing interfaces.  Thanks a lot.

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
