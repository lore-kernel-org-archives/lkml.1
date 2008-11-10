Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYKJOfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYKJOfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYKJOfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:35:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46674 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbYKJOfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:35:30 -0500
Date: Mon, 10 Nov 2008 14:35:22 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chandra Seetharaman <sekharan@us.ibm.com>,
       dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix dm_any_congested() to properly sync up with suspend code path)
Message-ID: <20081110143522.GE16649@agk.fab.redhat.com>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Chandra Seetharaman <sekharan@us.ibm.com>,
	dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org,
	axboe@kernel.dk
References: <1225944008.14830.1101.camel@chandra-ubuntu> <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com> <20081110135401.GA11606@infradead.org> <Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com> <1226327210.7685.173.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226327210.7685.173.camel@twins>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 03:26:50PM +0100, Peter Zijlstra wrote:
> Fix the infrastructure by adding a function call so that you can have
> the individual devices report their congestion state to the aggregate.
 
Which requires knowing/accessing some device hierarchy, which would be nice
for other things too (like propagation of notification of changes to device
properties such as size, hardsect size etc.).

Alasdair
-- 
agk@redhat.com
