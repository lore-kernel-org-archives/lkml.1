Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZCFHjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZCFHjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZCFHjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:39:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52060 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZCFHjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:39:23 -0500
Message-ID: <49B0D32A.9040807@cn.fujitsu.com>
Date: Fri, 06 Mar 2009 15:39:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
References: <49B0CAEC.80801@cn.fujitsu.com> <20090306072328.GL22605@hack.private>
In-Reply-To: <20090306072328.GL22605@hack.private>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +void *kmemdup_from_user(const void __user *src, size_t len, gfp_t gfp)
>> +{
>> +	void *p;
>> +
>> +	p = kmalloc_track_caller(len, gfp);
> 
> Well, you use kmalloc_track_caller, instead of kmalloc as you showed
> above. :) Why don't you mention this?
> 

Because this changelog is not going to explain what kmalloc_track_caller()
is used for, which has been explained in linux/slab.h ..

