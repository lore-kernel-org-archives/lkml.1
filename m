Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYIXFnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYIXFnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYIXFne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:43:34 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:49096 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844AbYIXFne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:43:34 -0400
Date: Wed, 24 Sep 2008 11:12:00 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080924054200.GA7103@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <1221869279.8359.31.camel@lappy.programming.kicks-ass.net> <20080922140740.GB5279@in.ibm.com> <1222094724.16700.11.camel@lappy.programming.kicks-ass.net> <1222147545.6875.135.camel@charm-linux> <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com> <1222228215.7761.0.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222228215.7761.0.camel@charm-linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 10:50:15PM -0500, Tom Zanussi wrote:
> 
> On Tue, 2008-09-23 at 07:00 -0700, Martin Bligh wrote:
> > > - get rid of anything having to do with padding, nobody needs it and its
> > > only affect has been to horribly distort and complicate a lot of the
> > > code
> > > - get rid of sub-buffers, they just cause confusion
> > > - get rid of mmap, nobody uses it
> > > - no sub-buffers and no mmap support means we can get rid of most of the
> > > callbacks, and a lot of API confusion along with them
> > > - add relay flags - they probably should have been used from the
> > > beginning and options made explicit instead of being shoehorned into the
> > > callback functions.
> > 
> > Actually, I think if you did all that, it'd be pretty close to what we
> > want anyway ...
> 
> OK, then, I'll continue with the cleanup patchset and see where it
> goes...
> 
> Tom
>
Hi Tom,
	Kindly let us know if the patches are available in some
downloadable location or have been maintained in a git tree.

I'm planning to re-base the relay_* interfaces (erstwhile 'trace' code),
to work on top of your patches.

Thanks,
K.Prasad
 
