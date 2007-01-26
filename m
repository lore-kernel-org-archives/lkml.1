Return-Path: <linux-kernel-owner+w=401wt.eu-S1030188AbXAZQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030188AbXAZQCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030559AbXAZQCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:02:52 -0500
Received: from rtr.ca ([64.26.128.89]:1511 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030188AbXAZQCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:02:51 -0500
Message-ID: <45BA2628.4030502@rtr.ca>
Date: Fri, 26 Jan 2007 11:02:48 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Denis Vlasenko <vda.linux@googlemail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org, kenneth.w.chen@in
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <45B90D19.60106@cfl.rr.com> <45B916F2.4070906@tls.msk.ru> <200701252211.39017.vda.linux@googlemail.com>
In-Reply-To: <200701252211.39017.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You guys need to backup in this thread.

Every example of O_DIRECT here could be replaced with
calls to mmap(), msync(), and madvise() (or posix_fadvise).

In addition to being at least as fast as O_DIRECT,
these have the added benefit of using the page cache 
(avoiding reads for data already present, handling multiple
users of the same data, etc..).

