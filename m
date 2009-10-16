Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZJPHlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZJPHlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZJPHlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:41:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45009 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745AbZJPHle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:41:34 -0400
Date: Fri, 16 Oct 2009 09:40:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: david@lang.hm
Cc: Greg KH <gregkh@suse.de>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: removing existing working drivers via staging
Message-ID: <20091016074039.GC30019@elte.hu>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de> <200910152020.13080.bzolnier@gmail.com> <20091015184656.GA29858@suse.de> <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm> <20091015191641.GB19467@elte.hu> <alpine.DEB.2.00.0910151230560.22169@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910151230560.22169@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* david@lang.hm <david@lang.hm> wrote:

> On Thu, 15 Oct 2009, Ingo Molnar wrote:
>
>> * david@lang.hm <david@lang.hm> wrote:
>>
>>>> But a driver in staging still has to be able to build, api changes
>>>> are not able to be ignored in it.
>>>
>>> a driver in staging will be able to build, but a driver that was
>>> removed after 6-9 months that a user discovered the removal of a year
>>> later when they upgraded to a new distro release (say a normal ubuntu
>>> release after staying on the old one for the 18 month support period)
>>> is likely to need significant work to catch up with kernel changes in
>>> the meanwhile.
>>
>> Where do you get the 6-9 months from? Greg said he'll wait 3 kernel
>> releases. Here's the timeline of that:
>
> that was the timeframe listed in the prior discussion, 3 kernel releases 
> * 2-3 months/release works out to this

We do 4 kernel releases a year - that's almost exactly 3 months per 
release - not 2-3 months.

It's one release per season / per quarter. That is a very natural 
frequency for releases: both in the biological and in the socio/economic 
spectrum.

Look at the release dates for version x, x-4 and x-8, they line up very 
nicely:

  v2.6.31: Date:   Wed Sep 9 15:13:59 2009 -0700
  v2.6.27: Date:   Thu Oct 9 15:13:53 2008 -0700
  v2.6.23: Date:   Tue Oct 9 13:31:38 2007 -0700

And that kind of release date reliability is intentional and i think can 
be expected to continue in the future as well. If you want to base 
products on Linux you really want to know the latencies of upstreaming 
and what to know when a driver or a kernel feature you'll rely on will 
be released.

[ .31 was a bit earlier - partly due to the KS (which always delays the
  cycle a tiny bit so it's good to save up for it) - and i'd personally
  not mind if we did the .33 merge window before Christmas, to avoid the
  distraction right in the middle of the holliday season. ]

Plus the inevitable fuzz of 1-2 weeks depending on the momentary QA 
situation.

	Ingo
