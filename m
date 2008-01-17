Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYAQMbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYAQMbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYAQMbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:31:05 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:57727 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751714AbYAQMbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:31:04 -0500
Date: Thu, 17 Jan 2008 23:28:57 +1100
From: CaT <cat@zip.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7: memory leak?
Message-ID: <20080117122856.GT3940@zip.com.au>
References: <20080117063410.GQ3940@zip.com.au> <1200568923.28661.9.camel@twins> <20080117114050.GR3940@zip.com.au> <1200571632.28661.13.camel@twins> <20080117121408.GS3940@zip.com.au> <1200572511.28661.20.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200572511.28661.20.camel@twins>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 01:21:51PM +0100, Peter Zijlstra wrote:
> > If that's the case it would seem to be somewhat of a pain to get and
> > kind of out of left field as I'd say most people would expect MemFree to
> > indicate the amount of memory that's no longer freely available
> > (ignoring swapping it out for simplicities sake).
> 
> I'm somewhat confused as to what you're saying. How would anyone expect
> MemFree to be memory that is _not_ freely available?

I think we have conflicting ideas of what 'freely available' means here
which is causing the confusion. :)

> Or are you asking how to compute the amount of freeable memory, that is
> memory that isn't currently free, but could be freed up under pressure?

Yes. I think I am. (heh)

> If that is indeed your question, then yes, thats rather hard as slabinfo
> and the like don't indicate which buckets have shrinkers (but even if

Ah. Foo.

> they would have shrinkers there is no guarantee they'd be able to shrink
> 100%)

Whacky.

:/

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
