Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbXEUJjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbXEUJjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXEUJjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:39:06 -0400
Received: from holomorphy.com ([66.93.40.71]:59051 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbXEUJjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:39:05 -0400
Date: Mon, 21 May 2007 02:39:58 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Scheduling tests on IPC methods, fc6, sd0.48, cfs12
Message-ID: <20070521093958.GI19966@holomorphy.com>
References: <464CE4AE.3030908@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464CE4AE.3030908@tmr.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 07:26:38PM -0400, Bill Davidsen wrote:
> I have posted the results of my initial testing, measuring IPC rates 
> using various schedulers under no load, limited nice load, and heavy 
> load at nice 0.
> http://www.tmr.com/~davidsen/ctxbench_testing.html

Kernel compiles are not how to stress these. The way to stress them is
to have multiple simultaneous independent chains of communicators and
deeper chains of communicators.

Kernel compiles are little but background cpu/memory load for these
sorts of tests. Something expected to have some sort of mutual
interference depending on quality of implementation would be a better
sort of competing load, one vastly more reflective of real workloads.
For instance, another set of processes communicating using the same
primitive.

Perhaps best of all would be a macrobenchmark utilizing a variety of
the primitives under consideration. Unsurprisingly, major commercial
databases do so for major benchmarks.


-- wli
