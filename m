Return-Path: <linux-kernel-owner+w=401wt.eu-S1423269AbXDYHck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423269AbXDYHck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423270AbXDYHcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:32:39 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3023 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423269AbXDYHci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:32:38 -0400
From: Vasily Tarasov <vtaras@openvz.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: OVZDL <devel@openvz.org>
References: <1177422791.435404.4031.nullmailer@me> <20070424170227.GB27887@kernel.dk> <20070424172228.GC27887@kernel.dk> <20070424172228.GC27887@kernel.dk>
In-Reply-To: <20070424172228.GC27887@kernel.dk>
Subject: Re: [PATCH] cfq: get rid of cfqq hash
Date: Wed, 25 Apr 2007 15:31:19 +0400
Message-Id: <1177500679.922374.3776.nullmailer@me>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Tarasov <vtaras@openvz.org>

>> -		if (key != CFQ_KEY_ASYNC)
>> +		if (!is_sync)
>>  			cfq_mark_cfqq_idle_window(cfqq);
>> +		else
>> +			cfq_mark_cfqq_sync(cfqq);
> 
> Woops, should be
> 
>         if (is_sync) {
>                 cfq_mark_cfqq_idle_window(cfqq);
>                 cfq_mark_cfqq_sync(cfqq);
>         }
> 
> of course.

Ugh!.. My fault, sorry.

Vasily
