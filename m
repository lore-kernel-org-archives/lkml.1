Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbXKITRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbXKITRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 14:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbXKITQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 14:16:52 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:51694 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbXKITQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 14:16:51 -0500
Message-ID: <4734B225.1050206@oracle.com>
Date: Fri, 09 Nov 2007 11:16:53 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-aio@kvack.org
Subject: Re: dio_get_page() lockdep complaints
References: <20070419073828.GB20928@kernel.dk>	<1194627742.6289.175.camel@twins>	<4734992C.7000408@oracle.com>	<1194630300.7459.65.camel@heimdal.trondhjem.org>	<47349D66.2040109@oracle.com>	<20071109130156.4b05a652@think.oraclecorp.com>	<4734A858.2010307@oracle.com>	<20071109135327.01bca1d9@think.oraclecorp.com> <20071109135736.04a4346a@think.oraclecorp.com>
In-Reply-To: <20071109135736.04a4346a@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Ugh, I thought the preallocation was getting freed elsewhere, but it
> looks like I was wrong.  We can't just skip the i_mutex after all,
> sorry.

Ah, so none of those tests at the top will stop tail packing if there's
been pre-allocation?

Like, uh, the inode reference count test?

- z
[ worried, and leaving it in your capable hands ]
