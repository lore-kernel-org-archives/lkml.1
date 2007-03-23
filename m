Return-Path: <linux-kernel-owner+w=401wt.eu-S934276AbXCWKei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276AbXCWKei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934281AbXCWKei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:34:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38387 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276AbXCWKeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:34:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: Greg KH <greg@kroah.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 0/21] MSI rework
References: <1174560686.307511.956605711793.qpush@cradle>
	<m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com>
	<20070322190834.GA14802@kroah.com>
	<1174600936.10836.53.camel@localhost.localdomain>
	<20070322220837.GD20713@kroah.com>
	<1174623443.5401.21.camel@concordia.ozlabs.ibm.com>
Date: Fri, 23 Mar 2007 04:25:26 -0600
In-Reply-To: <1174623443.5401.21.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Fri, 23 Mar 2007 15:17:23 +1100")
Message-ID: <m1ps705ka1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> On Thu, 2007-03-22 at 15:08 -0700, Greg KH wrote:
>> On Fri, Mar 23, 2007 at 09:02:16AM +1100, Benjamin Herrenschmidt wrote:
>> > > > i.e.  First the simple bug fixes that should purely be restructure of
>> > > > msi.c with no affect on anything outside of it.
>> > > > 
>> > > > And then get into the architecture enhancements.
>> > > 
>> > > I agree, care to break these down into a smaller series of patches that
>> > > can go into -mm for testing?
>> > 
>> > I don't see the point in breaking the serie... you can bisect half way
>> > through if necessary... it's made of small patches that are done, afaik,
>> > in such a way that the whole thing should still work at any level in the
>> > serie.
>> > 
>> > The serie just expresses the dependency between them.
>> 
>> Ok, then which patches in the series should be acceptable to take right
>> now for 2.6.22?  The "clean up the BUG" ones?
>
> The series is already very verbose, I don't think I can split most of
> them any smaller without producing an unbuildable kernel.

That wasn't the request.

> I think 1 up to and including 11 are safe as houses, they shouldn't have
> any effect other than to clean up the code.
>
> The rest make functional changes, but they're all quite small, self
> contained, and easily bisectable. I'd certainly like Eric to have a look
> at them, but at some point I think we're just going to have to bite the
> bullet and merge them, and see what we get in the way of bug reports.

What I wanted was the patches organized into functional groups that
were small enough to review as a unit.  (Feed the existing patches slower
please).

This seems to be to much change to read and review as a unit, I just get
bleary eyed, and start to get confused.

So far I have found one subtle bug.  Where admittedly my code wasn't as
obvious as it could be and you were proposing to use an irq that had already
been freed.

What I had hoped we can do is you would send a handful at a time I
would review them.  Then we could get the next handful.  I expect
doing it that way it should take about a week to get through them all.

I guess I can try going through the review that way as well.  Pick a
subset of what you have sent and review it very carefully, and the
next day pick a different subset.  

I have been sufficiently active in this code lately that I think I can
do a good review, and I want to.  Unfortunately I'm only human and
a good review is nearly as much work as writing the patches myself
which means it takes time.

Eric
