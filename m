Return-Path: <linux-kernel-owner+w=401wt.eu-S1030889AbXAZQxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030889AbXAZQxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030875AbXAZQw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:52:58 -0500
Received: from mx27.mail.ru ([194.67.23.64]:23134 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030882AbXAZQwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:52:20 -0500
Message-ID: <45BA31B3.2020203@inbox.ru>
Date: Fri, 26 Jan 2007 19:52:03 +0300
From: Viktor <vvp01@inbox.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20060212 Fedora/1.7.12-5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Denis Vlasenko <vda.linux@googlemail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@osdl.org>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <45B90D19.60106@cfl.rr.com> <45B916F2.4070906@tls.msk.ru> <200701252211.39017.vda.linux@googlemail.com> <45BA2628.4030502@rtr.ca>
In-Reply-To: <45BA2628.4030502@rtr.ca>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> You guys need to backup in this thread.
> 
> Every example of O_DIRECT here could be replaced with
> calls to mmap(), msync(), and madvise() (or posix_fadvise).

No. How about handling IO errors? There is no practical way for it with
mmap().

> In addition to being at least as fast as O_DIRECT,
> these have the added benefit of using the page cache 
> (avoiding reads for data already present, handling multiple
> users of the same data, etc..).
> 
> 

