Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYKQILP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYKQILP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYKQIK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:10:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:51171 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYKQIK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:10:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=aS5igmmktr7a2fiJJb+XkWnXMhpJd/vxOMUjW66HBau0x/iY/fAr/OGO7RBGz3uHAs
         t1KnUC4MxgFREvjZFHkzU3f1xzjwW9+W1jbaQh5rTuDkYrCOLbafyyHulFb8rRnC+h5v
         4Ye6fGrgQWWvw5rhstsA+czh6jvOkLaCn5Sr4=
Message-ID: <2f11576a0811170010u19ef4e3qf81639a75f8bbabe@mail.gmail.com>
Date: Mon, 17 Nov 2008 17:10:57 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       balbir@linux.vnet.ibm.com, laijs@cn.fujitsu.com, arjan@infradead.org,
       airlied@gmail.com, menage@google.com, jens.axboe@oracle.com,
       jack@suse.cz, jes@sgi.com, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, adobriyan@gmail.com
In-Reply-To: <20081116.231555.190117597.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081117142539.9b2c6bfc.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f11576a0811162243r7527d271ya8ab2fc3a9be9f7d@mail.gmail.com>
	 <20081116231301.c6b0da95.akpm@linux-foundation.org>
	 <20081116.231555.190117597.davem@davemloft.net>
X-Google-Sender-Auth: 01af146792f9cb7e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/17 David Miller <davem@davemloft.net>:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Sun, 16 Nov 2008 23:13:01 -0800
>
>> In fact it's not immediately clear why __vmalloc() takes a gfp_t
>> argument either?
>
> Probably for things like GFP_DMA32, GFP_HIGHMEM, et al.

Thanks.

I think to __GFP_ZERO or __GFP_COLD etc..
but that also is right, imho.
