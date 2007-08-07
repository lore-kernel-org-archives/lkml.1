Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbXHGMFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbXHGMFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXHGMF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:05:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24450 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbXHGMF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:05:27 -0400
Date: Tue, 7 Aug 2007 14:05:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Distributed storage.
Message-ID: <20070807120523.GX5245@kernel.dk>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708050104.19596.phillips@phunq.net> <20070805150824.GB32132@2ka.mipt.ru> <200708051423.45484.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708051423.45484.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05 2007, Daniel Phillips wrote:
> A simple way to solve the stable accounting field issue is to add a new 
> pointer to struct bio that is owned by the top level submitter 
> (normally generic_make_request but not always) and is not affected by 
> any recursive resubmission.  Then getting rid of that field later 
> becomes somebody's summer project, which is not all that urgent because 
> struct bio is already bloated up with a bunch of dubious fields and is 
> a transient structure anyway.

Thanks for your insights. Care to detail what bloat and dubious fields
struct bio has?

And we don't add temporary fields out of laziness, hoping that "someone"
will later kill it again and rewrite it in a nicer fashion. Hint: that
never happens, bloat sticks.

-- 
Jens Axboe

