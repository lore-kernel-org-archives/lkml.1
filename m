Return-Path: <linux-kernel-owner+w=401wt.eu-S966315AbXEVSa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966315AbXEVSa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759829AbXEVSaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:30:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48863 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759648AbXEVSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:30:14 -0400
Date: Tue, 22 May 2007 11:30:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Hugh Dickins <hugh@veritas.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>, Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <20070522153622.GZ4705@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705221129151.29456@schroedinger.engr.sgi.com>
References: <559665.2852.qm@web52608.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705221358360.4904@blonde.wat.veritas.com>
 <20070522153622.GZ4705@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Jens Axboe wrote:

> > You've made no mention of trying the patch I sent yesterday, or better,
> > the patch Christoph replied with to replace it.  Please clarify whether
> > you're getting the above after applying one of those patches - thanks.
> 
> Christophs patch works for me!

So you are able to run slub with the patch and 

1. CONFIG_NUMA set (CONFIG_SMP works fine here too)

2. CONFIG_LOCKDEP

3. CONFIG_DEBUG_LOCK_ALLOCS

?

That fails here.

