Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZHSWXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZHSWXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZHSWXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:23:23 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:33647 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZHSWXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:23:22 -0400
Subject: Re: [PATCH 0/4] Page based O_DIRECT v2
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, zach.brown@oracle.com, hch@infradead.org
In-Reply-To: <20090819220640.GW12579@kernel.dk>
References: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com>
	 <1250708742.5589.23.camel@cail>  <20090819220640.GW12579@kernel.dk>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 18:23:24 -0400
Message-Id: <1250720604.5589.50.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 00:06 +0200, Jens Axboe wrote:

> 
> Thanks a lot for the test run, Alan. I wonder why writes are down while
> reads are up. One possibility could be a WRITE vs WRITE_ODIRECT
> difference, though I think they should be the same. The patches I posted
> have not been benchmarked at all, it's still very much a work in
> progress. I just wanted to show the general direction that I thought
> would be interesting. So I have done absolutely zero performance
> testing, it's only been tested for whether it still worked or not (to
> some degree :-)...
> 
> I'll poke a bit at it here, too. I want to finish the unplug/wait
> problem first. Is your test case using read/write or readv/writev?
> 

Hi Jens - I just had some extra cycles, so figured what the heck... :-)

Actually, this is using asynchronous direct I/Os (libaio/Linux native
AIO). If I get a chance tomorrow, I'll play with read/write (and/or
readv/writev). 

Alan

