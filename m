Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbXKISys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbXKISys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXKISyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:54:41 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54694 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbXKISyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:54:40 -0500
Date: Fri, 9 Nov 2007 13:53:27 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-aio@kvack.org
Subject: Re: dio_get_page() lockdep complaints
Message-ID: <20071109135327.01bca1d9@think.oraclecorp.com>
In-Reply-To: <4734A858.2010307@oracle.com>
References: <20070419073828.GB20928@kernel.dk>
	<1194627742.6289.175.camel@twins>
	<4734992C.7000408@oracle.com>
	<1194630300.7459.65.camel@heimdal.trondhjem.org>
	<47349D66.2040109@oracle.com>
	<20071109130156.4b05a652@think.oraclecorp.com>
	<4734A858.2010307@oracle.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2007 10:35:04 -0800
Zach Brown <zach.brown@oracle.com> wrote:

> > Without getting into a huge patch, the best fix would just be
> > switching to try lock.  If the tail doesn't get packed, the world
> > doesn't end.
> 
> So, something like this?

Reviewed-by: Chris Mason <chris.mason@oracle.com>

-chris
