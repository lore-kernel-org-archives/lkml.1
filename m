Return-Path: <linux-kernel-owner+w=401wt.eu-S1030200AbXCOMzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200AbXCOMzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXCOMzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:55:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41404 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200AbXCOMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:55:36 -0400
Date: Thu, 15 Mar 2007 13:54:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch 1/2] splice: dont steal
Message-ID: <20070315125432.GT15400@kernel.dk>
References: <20070314121440.GA926@wotan.suse.de> <20070315115237.GM15400@kernel.dk> <20070315122207.GA8321@wotan.suse.de> <20070315122723.GQ15400@kernel.dk> <20070315124531.GD8321@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315124531.GD8321@wotan.suse.de>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15 2007, Nick Piggin wrote:
> On Thu, Mar 15, 2007 at 01:27:23PM +0100, Jens Axboe wrote:
> > On Thu, Mar 15 2007, Nick Piggin wrote:
> > > 
> > > We should be able to allow for it with the new a_ops API I'm working
> > > on.
> > 
> > "Should be" and in progress stuff, is it guarenteed to get there?
> 
> Well considering that it is needed in order to solve 3 different deadlock
> scenarios in the core write(2) path without taking a big performance hit,
> I'd hope so ;)
> 
> It isn't guaranteed, but I have only had positive feedback so far. Would
> take a while to actually get merged, though.

It's not that I don't believe you, I'm just a little reluctant to rip
stuff out with a promise to fix it later when foo and bar are merged,
since things like that have a tendency not to get done because they are
forgotten :-)

Do you have a test case for stealing failures? What I'm really asking is
how critical is this?

-- 
Jens Axboe

