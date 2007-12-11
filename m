Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbXLKTjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbXLKTjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbXLKTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:39:05 -0500
Received: from phunq.net ([64.81.85.152]:54507 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751706AbXLKTjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:39:04 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Date: Tue, 11 Dec 2007 11:38:57 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712100617.24157.phillips@phunq.net> <20071211131514.GB25437@kernel.dk>
In-Reply-To: <20071211131514.GB25437@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712111138.58197.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007 05:15, Jens Axboe wrote:
> On Mon, Dec 10 2007, Daniel Phillips wrote:
> > Now about that block writeout deadlock... it doesn't just affect my
> > code, it basically breaks Linux as a storage platform, among other
> > things.
>
> As written in other similar threads in the past in which you also
> participated, I still of the opinion that this is a vm issue and
> should be solved as such.

The problem is solved.  The main cornerstone of the solution is
bio throttling, simply because the resources in question are consumed by 
bio transactions.

> As to the patch in question "fixing" it in the block layer, it's a
> fairly simple work around and I'm not totally against it. If you get
> rid of the ->bi_throttle stuff and just do sanity checks on the
> count, then we could look at getting some testing done.

Testing is already progressing fine without you, thankyou.  If you do 
want to participate, welcome, otherwise it is not a problem.  Thanks 
for picking up that bug yesterday.

Daniel
