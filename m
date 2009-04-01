Return-Path: <linux-kernel-owner+w=401wt.eu-S1764792AbZDAWTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764792AbZDAWTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbZDAWTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:19:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:51613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996AbZDAWTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:19:42 -0400
Message-ID: <49D3E8A2.6070604@kernel.org>
Date: Thu, 02 Apr 2009 07:20:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 10/17] bio: use bio_create_from_sgl() in bio_map_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-11-git-send-email-tj@kernel.org> <49D3974F.6080601@panasas.com>
In-Reply-To: <49D3974F.6080601@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 22:19:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
>>  		ret = get_user_pages_fast(uaddr, local_nr_pages, rw == READ,
>> -					  &pages[cur_page]);
>> +					  &pages[nents]);
> 
> Fast look at all users of get_user_pages_fast().
> 
> This can be converted to take an sglist instead of pages* array.
> Outside of this code all users either have a fixed-size allocated array
> or hard coded one page. This here is the main user. (Out of 5)

Yeah, that would be nice, although it's understandable that gup taking
page array as parameter.

Thanks.

-- 
tejun
