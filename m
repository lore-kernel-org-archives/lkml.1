Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXLKULS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXLKULS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXLKULH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:11:07 -0500
Received: from phunq.net ([64.81.85.152]:56236 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752322AbXLKULE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:11:04 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Date: Tue, 11 Dec 2007 12:11:00 -0800
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712111138.58197.phillips@phunq.net> <20071211200149.GA1927@kernel.dk>
In-Reply-To: <20071211200149.GA1927@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712111211.00559.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007 12:01, Jens Axboe wrote:
> On Tue, Dec 11 2007, Daniel Phillips wrote:
> > The problem is solved.  The main cornerstone of the solution is
> > bio throttling, simply because the resources in question are
> > consumed by bio transactions.
>
> ... because too much is pushed out. This isn't a mathematica problem,
> there's more than one solution to this problem. Throttling the bio
> count is one.

And nobody has been able to find another.  Funny that.  In fact, every 
solution proposed so far has implicitly required the writeout traffic 
to be throttled, even if that throttling was not part of the patch.  
Without throttling, deadlock.  Simple as that.
