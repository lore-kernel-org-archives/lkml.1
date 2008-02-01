Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbYBALWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbYBALWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbYBALWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:22:42 -0500
Received: from brick.kernel.dk ([87.55.233.238]:29803 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692AbYBALWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:22:41 -0500
Date: Fri, 1 Feb 2008 12:22:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bug] as_merged_requests(): possible recursive locking detected
Message-ID: <20080201112238.GN15220@kernel.dk>
References: <20080131221436.GA3760@elte.hu> <20080201084056.GH15220@kernel.dk> <20080201104537.GA27178@elte.hu> <20080201104733.GM15220@kernel.dk> <20080201110123.GF27178@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201110123.GF27178@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, Feb 01 2008, Ingo Molnar wrote:
> > > 
> > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > Are you sure this triggered with the as fixup in place? It looks like 
> > > > the same bug.
> > > 
> > > most definitely a separate bug.
> > 
> > yeah, I didn't read it carefully enough. Nikanth found the reason.
> 
> /me processes his mbox some more and sees the mails
> 
> am i right that lockdep complained about real lockup potential here? 
> (i.e. it caught a real bug) So there's no need to change anything on the 
> lockdep side, right?

Right, no bug in lockdep, the locking code and swap_io_context() are
just screwed up.

-- 
Jens Axboe

