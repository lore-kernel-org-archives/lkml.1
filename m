Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbXLJNoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbXLJNoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbXLJNny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:43:54 -0500
Received: from phunq.net ([64.81.85.152]:53039 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751705AbXLJNnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:43:53 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Date: Mon, 10 Dec 2007 05:43:45 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712100526.49319.phillips@phunq.net> <20071210133050.GJ5008@kernel.dk>
In-Reply-To: <20071210133050.GJ5008@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712100543.45204.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007 05:30, Jens Axboe wrote:
> On Mon, Dec 10 2007, Daniel Phillips wrote:
> "Let me close with perhaps the most relevant remarks: the attached
> code has been in heavy testing and in production for months now. 
> Thus there is nothing theoretical when I say it works, and the patch
> speaks for itself in terms of obvious correctness."

That is quite correct, even without the redirect the code passed all our 
tests.  Remember, we were testing for deadlock, not every possible 
block IO configuration.

> We must have differing opinions on what obvious correctness is.

Yes we do.  You appear to have missed the plot entirely.  I suppose I 
should remind you: this is about deadlock in _your_ subsystem that has 
been creating bug reports for years.  Block writeout deadlock.  Caused 
by a deficiency in _your_ subsystem.

Got a plan?  Or does endless, pointless flaming feel more like progress 
to you?
