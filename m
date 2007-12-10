Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbXLJM2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbXLJM2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXLJM2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:28:07 -0500
Received: from phunq.net ([64.81.85.152]:53372 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751973AbXLJM2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:28:06 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Date: Mon, 10 Dec 2007 04:27:58 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712100413.38077.phillips@phunq.net> <20071210121627.GF5008@kernel.dk>
In-Reply-To: <20071210121627.GF5008@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712100427.58288.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007 04:16, Jens Axboe wrote:
> OK, let me get the neon out then. This has nothing to do with
> throttling, I thought I made it clear that I get why you store the
> origin queue in ->bi_queue. I'm concerned with the workings of
> redirecting a bio. Previously we looked up the queue associated with
> bio->bi_bdev inside the loop in __generic_make_request(), as is
> REQUIRED to correctly locate a DIFFERENT queue if bio->bi_bdev has
> been changed to point somewhere else.

Rhetoric aside, again.

We are only interested in throttling against the bio->bi_bdev that was 
stored in the bio at the time of the call to generic_make_request, why 
should we care about the redirected value?

Regards,

Daniel
