Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbXEUTJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbXEUTJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbXEUTJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:09:47 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:40859
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbXEUTJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:09:46 -0400
Date: Mon, 21 May 2007 12:09:17 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521190917.GB20136@gnuppy.monkey.org>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org> <20070521075013.GA9419@elte.hu> <20070521091848.GB4593@gnuppy.monkey.org> <20070521093639.GA29025@elte.hu> <20070521101946.GC4593@gnuppy.monkey.org> <20070521124655.GA411@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521124655.GA411@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 02:46:55PM +0200, Ingo Molnar wrote:
> which combines into this statement of yours: "I audited 1600 something 
> lock points in the kernel to convert the usage of C99 style initializers 
> something more regular, only to find out that there wasn't much left to 
> convert over?", correct? Which begs the question: why did you mention 
> this then at all? I usually reply to points made by others in the 
> assumption that there's some meaning behind them ;-)

It was about how much time I wasted replicating work that I didn't know
about. Some folks have different communication styles and it isn't ment
to be anything further than that.

Me and Peter are talking about possibly merging parts of each other's
patch. I've been working on splitting up the reader/writer paths so that
each type of contention is logged as well for tracking reader contentions
against that existing rwsem problem and the like, but my stuff doesn't
boot yet (working part time drags things). I/We'll keep you updated.

bill

