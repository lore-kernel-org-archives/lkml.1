Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbYBROQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbYBROQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYBROQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:16:19 -0500
Received: from brick.kernel.dk ([87.55.233.238]:12833 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYBROQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:16:18 -0500
Date: Mon, 18 Feb 2008 15:16:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, dgc@sgi.com, arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
Message-ID: <20080218141614.GD23197@kernel.dk>
References: <47B0B69B.1050807@hp.com> <47B46008.9020804@hp.com> <20080218123717.GW23197@kernel.dk> <p73ablyxuci.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ablyxuci.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18 2008, Andi Kleen wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > and that scrapping the remote
> > softirq trigger stuff is sanest.
> 
> I actually liked Nick's queued smp_function_call_single() patch. So even
> if it was not used for block I would still like to see it being merged 
> in some form to speed up all the other IPI users.

Sure, Nicks patch was generically usable, my IPI stuff was just a hack
made to go as fast as possible for a single use. The current
call-on-other cpu path is not exactly scalable...

-- 
Jens Axboe

