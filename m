Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXEAXSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXEAXSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXEAXSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:18:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14438 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbXEAXSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:18:05 -0400
Date: Tue, 1 May 2007 16:17:22 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bill Irwin <bill.irwin@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
Message-ID: <20070501231722.GV26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
	Ulrich Drepper <drepper@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
References: <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org> <20070410004201.GA2986@holomorphy.com> <20070501172937.GQ26598@holomorphy.com> <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com> <20070501202456.GR26598@holomorphy.com> <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com> <20070501222724.GG26093@thunk.org> <20070501223440.GT26598@holomorphy.com> <20070502000458.2a7885d9@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502000458.2a7885d9@the-village.bc.nu>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At some point in the past, I wrote:
>> I just so happen to think we should implement a variety of CPU resource
>> limits beyond what we now do, so this, too, interests me.

On Wed, May 02, 2007 at 12:04:58AM +0100, Alan Cox wrote:
> Agreed - and make them all 64bit while doing the cleanup. One thing
> several Unixen have we don't for 32bi boxes is a proper set of 64bit
> resource handling for memory/file etc.
> We could also start using the CPU facilities to enforce some of
> the really interesting real time process ones (like main memory
> bandwidth) that at the moment we have no control over and can lead to
> very unfair behaviour.

That would be very useful, though I'm unsure of how broad a variety of
architectures implement performance counters useful for such. Simple
caps on %cpu would be a good start in my view.


-- wli
