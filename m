Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYDPSsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYDPSsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYDPSsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:48:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1421 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750754AbYDPSse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:48:34 -0400
Date: Wed, 16 Apr 2008 20:44:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, paolo.valente@unimore.it
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080416184441.GA3923@ucw.cz>
References: <20080401152903.GB34860@gandalf.sssup.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401152903.GB34860@gandalf.sssup.it>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-04-01 17:29:03, Fabio Checconi wrote:
> [sorry for reposting, wrong subject]
> 
> Hi,
>     we are working to a new I/O scheduler based on CFQ, aiming at
> improved predictability and fairness of the service, while maintaining
> the high throughput it already provides.
> 
> The patchset, too big for lkml posting, is available here:
>     http://feanor.sssup.it/~fabio/linux/bfq/patches/
> 
> The Budget Fair Queueing (BFQ) scheduler turns the CFQ Round-Robin
> scheduling policy of time slices into a fair queueing scheduling
> of sector budgets.  More precisely, each task is assigned a budget
> measured in number of sectors instead of amount of time, and budgets
...
> In the first type of tests, to achieve a higher throughput than CFQ
> (with the default 100 ms time slice), the maximum budget for BFQ
> had to be set to at least 4k sectors.  Using the same value for the

Hmm, 4k sectors is ~40 seconds worst case, no? That's quite long...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
