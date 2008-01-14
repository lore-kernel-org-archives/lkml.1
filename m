Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYANNpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYANNpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYANNp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:45:26 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38571 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYANNp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:45:26 -0500
To: peterz@infradead.org
CC: salikhmetov@gmail.com, linux-mm@kvack.org, jakob@unthought.net,
       linux-kernel@vger.kernel.org, valdis.kletnieks@vt.edu, riel@redhat.com,
       ksm@42.dk, staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, nickpiggin@yahoo.com.au
In-reply-to: <1200317990.15103.11.camel@twins> (message from Peter Zijlstra on
	Mon, 14 Jan 2008 14:39:50 +0100)
Subject: Re: [PATCH 2/2] updating ctime and mtime at syncing
References: <12001991991217-git-send-email-salikhmetov@gmail.com>
	 <12001992023392-git-send-email-salikhmetov@gmail.com>
	 <E1JENAv-0007CM-T9@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801140422l1980d507v1884ad8d8e8bf6d3@mail.gmail.com>
	 <E1JEP9P-0007RD-PP@pomaz-ex.szeredi.hu>  <1200317737.15103.8.camel@twins> <1200317990.15103.11.camel@twins>
Message-Id: <E1JEPcs-0007V6-Oy@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Jan 2008 14:45:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> More fun, it would require marking them RO but leaving the dirty bit
> set, because this ext3 fudge where we confuse the page dirty state - or
> did that get fixed?

That got fixed by Nick, I think.

The alternative to marking pages RO, is to walk the PTEs in MS_ASYNC,
note the dirty bit and mark pages clean.  But it's possibly even more
complicated.

Miklos
