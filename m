Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbXEUGFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbXEUGFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXEUGFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:05:09 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:49539
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbXEUGFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:05:07 -0400
Date: Sun, 20 May 2007 23:04:46 -0700
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521060446.GA4593@gnuppy.monkey.org>
References: <1179657026.5915.10.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179657026.5915.10.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 12:30:26PM +0200, Peter Zijlstra wrote:
> The 4 points are the first 4 unique callsites that cause lock contention
> for the specified lock class.
> 
> writing a 0 to /proc/lockdep_contentions clears the stats

We should talk about unifying it with my lockstat work for -rt so that
we have a comprehensive solution for the "world". But you know that
already :)

Unifying lock initializer hash key initialization functions is a key
first step to that. Keep in mind, we can do more with this mechanism
than just kernel locks and we should probably keep that open and not
code into a corner.

bill

