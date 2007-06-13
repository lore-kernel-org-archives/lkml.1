Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbXFMA2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbXFMA2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 20:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbXFMA1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 20:27:54 -0400
Received: from ozlabs.org ([203.10.76.45]:46850 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbXFMA1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 20:27:53 -0400
Subject: Re: [PATCH 4/9] readahead: data structure and routines
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
In-Reply-To: <20070612120706.GB9624@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
	 <20070516224818.683288460@mail.ustc.edu.cn>
	 <1181619050.6237.23.camel@localhost.localdomain>
	 <20070612120706.GB9624@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 10:27:19 +1000
Message-Id: <1181694439.6237.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 20:07 +0800, Fengguang Wu wrote:
> Hi Rusty,

Hi Fengguang,

> or preferably:
> 
> 	pgoff_t start;                 /* where readahead started */
>         unsigned long size;            /* # of readahead pages */
> 	unsigned long async_size;      /* do asynchronous readahead when there are only # of pages ahead */
> 
> 	unsigned long async_size_old;  /* TODO: this one is not needed for now */
> 
> Any opinions? Thanks.

These names and comments are really nice.  I think the code will become
more readable after this, too.

Did you want me to try to make this patch, or did you want to do it?

Thanks,
Rusty.


