Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbXCVN6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbXCVN6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932634AbXCVN6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:58:40 -0400
Received: from brick.kernel.dk ([62.242.22.158]:1512 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652AbXCVN6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:58:39 -0400
Date: Thu, 22 Mar 2007 14:54:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
Message-ID: <20070322135456.GS19922@kernel.dk>
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com> <20070322134230.GP19922@kernel.dk> <20070322145245.a49fefeb.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322145245.a49fefeb.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22 2007, Eric Dumazet wrote:
> On Thu, 22 Mar 2007 14:42:31 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> 
> > > This time, you would be limited to 16384 loop devices on x86_64, 32768 on i386 :)
> > 
> > But this still wastes memory, why not just allocate each loop device
> > dynamically when it is set up? The current approach is crap, it is just
> > wasting memory for loop devices, queues, etc.
> > 
> 
> Sure, but it's the first Tomas patch :)

The more the reason to guide him in the direction of a right solution,
instead of extending the current bad one!

> Apparently the 'current crap' didnt caugth someone else attention.

I guess most people don't care, 8 is enough for them and the wasted
memory isn't too much to care about - 8 devices and only one used, is
wasting at least ~14kb on my machine here.

-- 
Jens Axboe

