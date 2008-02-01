Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbYBALsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbYBALsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760669AbYBALs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:48:26 -0500
Received: from mail.suse.de ([195.135.220.2]:58537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325AbYBALsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:48:25 -0500
Subject: Re: Fwd: [bug] as_merged_requests(): possible recursive locking
	detected
From: Nikanth Karthikesan <knikanth@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47A35177.BANGALORE.BLR.100.174746A.1.1085C.1@1:7.BANGALORE.BLR.100.0.1.0.1@16>
References: <20080131221436.GA3760@elte.hu>
	 <20080201084056.GH15220@kernel.dk> <20080201104537.GA27178@elte.hu>
	 <20080201104733.GM15220@kernel.dk> <20080201110123.GF27178@elte.hu>
	 <20080201112238.GN15220@kernel.dk>
	 <47A35177.BANGALORE.BLR.100.174746A.1.1085C.1@1:7.BANGALORE.BLR.100.0.1.0.1@16>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 17:23:42 +0530
Message-Id: <1201866822.12473.6.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > am i right that lockdep complained about real lockup potential here?
> > (i.e. it caught a real bug) So there's no need to change anything on the
> > lockdep side, right?
> 
> Right, no bug in lockdep, the locking code and swap_io_context() are
> just screwed up.
> 

I doubt a bug in lockdep. Here we just swap the pointers but use the
addresses themselves to order locks. And we do not change the
contents(lock) in those addresses. So it could be a lockdep bug.

Thanks
Nikanth Karthikesan



