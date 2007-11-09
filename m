Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbXKIRsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbXKIRsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 12:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXKIRsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 12:48:23 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:54462 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbXKIRsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 12:48:23 -0500
Message-ID: <47349D66.2040109@oracle.com>
Date: Fri, 09 Nov 2007 09:48:22 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-aio@kvack.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: dio_get_page() lockdep complaints
References: <20070419073828.GB20928@kernel.dk>	 <1194627742.6289.175.camel@twins>  <4734992C.7000408@oracle.com> <1194630300.7459.65.camel@heimdal.trondhjem.org>
In-Reply-To: <1194630300.7459.65.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> So reiser and NFS need to be fixed.  No?
> 
> Actually, it is rather mmap() needs to be fixed.

Sure, I'm willing to have that demonstrated.  My point was that DIO
getting the mmap_sem inside i_mutex is currently correct.

reiserfs, though, seems to be out on a more precarious limb ;).

- z
