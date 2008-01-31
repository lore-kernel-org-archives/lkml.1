Return-Path: <linux-kernel-owner+w=401wt.eu-S1765127AbYAaJsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765127AbYAaJsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYAaJr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:47:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58108 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYAaJr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:47:56 -0500
Date: Thu, 31 Jan 2008 01:47:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: hugh@veritas.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       npiggin@suse.de, riel@redhat.com, mztabzr@0pointer.de, mpm@selenic.com
Subject: Re: [PATCH] mm: MADV_WILLNEED implementation for anonymous memory
Message-Id: <20080131014702.705f1040.akpm@linux-foundation.org>
In-Reply-To: <1201772118.28547.254.camel@lappy>
References: <1201714139.28547.237.camel@lappy>
	<20080130144049.73596898.akpm@linux-foundation.org>
	<1201769040.28547.245.camel@lappy>
	<20080131011227.257b9437.akpm@linux-foundation.org>
	<1201772118.28547.254.camel@lappy>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 10:35:18 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Thu, 2008-01-31 at 01:12 -0800, Andrew Morton wrote:
> 
> > Implementation-wise: make_pages_present() _can_ be converted to do this. 
> > But it's a lot of patching, and the result will be a cleaner, faster and
> > smaller core MM.  Whereas your approach is easy, but adds more code and
> > leaves the old stuff slow-and-dirty.
> > 
> > Guess which approach is preferred? ;)
> 
> Ok, I'll look at using make_pages_present().

Am still curious to know what inspired this change.  What are the use
cases?  Performance testing results, etc?
