Return-Path: <linux-kernel-owner+w=401wt.eu-S1750837AbXDSOXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837AbXDSOXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXDSOXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:23:08 -0400
Received: from brick.kernel.dk ([80.160.20.94]:3469 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbXDSOXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:23:06 -0400
Date: Thu, 19 Apr 2007 16:20:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, reiserfs-dev@namesys.com, linux-mm@kvack.org
Subject: Re: dio_get_page() lockdep complaints
Message-ID: <20070419142035.GH11780@kernel.dk>
References: <20070419073828.GB20928@kernel.dk> <20070419012540.bed394e2.akpm@linux-foundation.org> <20070419083407.GD20928@kernel.dk> <200704191643.38367.vs@namesys.com> <20070419124933.GE11780@kernel.dk> <20070419125236.GF11780@kernel.dk> <adavefstqq4.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adavefstqq4.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19 2007, Roland Dreier wrote:
> Maybe you could add some hack really early on (say at the beginning of
> the reiserfs mount code) that took instances of the locks in the
> correct order, so you would get a lockdep trace of where the ordering
> is violated when it first happens?

See the test case mail I sent out.

-- 
Jens Axboe

