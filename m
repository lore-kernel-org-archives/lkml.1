Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYAQMQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYAQMQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYAQMQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:16:15 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:39848 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751328AbYAQMQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:16:15 -0500
Date: Thu, 17 Jan 2008 23:14:08 +1100
From: CaT <cat@zip.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7: memory leak?
Message-ID: <20080117121408.GS3940@zip.com.au>
References: <20080117063410.GQ3940@zip.com.au> <1200568923.28661.9.camel@twins> <20080117114050.GR3940@zip.com.au> <1200571632.28661.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200571632.28661.13.camel@twins>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 01:07:12PM +0100, Peter Zijlstra wrote:
> On Thu, 2008-01-17 at 22:40 +1100, CaT wrote:
> > > How much memory does:
> > > 
> > >   echo 3 > /proc/sys/vm/drop_caches
> > > 
> > > gain you?
> > 
> > 56M used now. 
> 
> Good :-)

Indeed. :)

> > Should all this cache usage not be counted towards the
> > 'Cached' entry in meminfo rather then getting counted as part of used
> > ram. 
> 
> Cached is only the page-cache, not all the other caches we have..
> This someones confuses people, but one gets used to it. slabinfo allows
> one to easily view others.

So what would I have to do to find out the real amount of memory free?
Would that be the MemFree field in /proc/meminfo plus, from
/proc/slabinfo, *_cache and size-*?

If that's the case it would seem to be somewhat of a pain to get and
kind of out of left field as I'd say most people would expect MemFree to
indicate the amount of memory that's no longer freely available
(ignoring swapping it out for simplicities sake).

I'm wondering as I'm trying to monitor this stuff and I've just found
out that the easily accessible values are not as useful as I previously
thought.

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
