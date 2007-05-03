Return-Path: <linux-kernel-owner+w=401wt.eu-S1161821AbXECKbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161821AbXECKbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161817AbXECKbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:31:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59841 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161821AbXECKbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:31:52 -0400
Date: Thu, 3 May 2007 12:31:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070503103148.GA18822@one.firstfloor.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org> <20070502231104.GA26045@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502231104.GA26045@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If we are looking at current "potential users" that are already in
> mainline, we could change blktrace to make it use the markers.

Ok, but do it step by step:
- split out useful pieces like the "patched in enable/disable flags" 
and submit them separate with an example user or two 
[I got a couple of candidates e.g. with some of the sysctls in VM or 
networking] 
- post and merge that.
- don't implement anything initially that is not needed by blktrace
- post a minimal marker patch together with the blktrace
conversion for review again on linux-kernel
- await review comments. This review would not cover the basic
need of markers, just the specific implementation.
- then potentially merge incorporate review comments
- then merge
- later add features with individual review/discussion as new users in the 
kernel are added.

-Andi
