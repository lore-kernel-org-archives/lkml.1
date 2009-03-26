Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbZCZToI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbZCZToI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760988AbZCZTnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:43:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56885 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760770AbZCZTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:43:48 -0400
Date: Thu, 26 Mar 2009 19:43:04 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       tytso@mit.edu, jack@suse.cz, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
       jens.axboe@oracle.com, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, oleg@redhat.com, roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency measurements)
Message-ID: <20090326194304.GA10018@srcf.ucam.org>
References: <20090325123744.GK23439@duck.suse.cz> <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain> <20090326092454.b74e3f96.akpm@linux-foundation.org> <200903261812.09153.elendil@planet.nl> <20090326104843.46abfaa7.akpm@linux-foundation.org> <20090326184900.GA8580@srcf.ucam.org> <20090326122003.5f6f608c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326122003.5f6f608c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 12:20:03PM -0700, Andrew Morton wrote:
> On Thu, 26 Mar 2009 18:49:00 +0000 Matthew Garrett <mjg@redhat.com> wrote:
> > On Thu, Mar 26, 2009 at 10:48:43AM -0700, Andrew Morton wrote:
> > There has to be a default. 24 hours is a sensible one.
> 
> "default" implies that it can be altered by some means.

You need a default even in the tunable case.

> > When did we adopt a mindset that led to code having to satisfy every 
> > single user requirement before being accepted, rather than being happy 
> > with code that provides an incremental improvement over what exists 
> > already?
> 
> Shortcomings have been identified.  Weaselly verbiage is not a suitable
> way of addressing shortcomings!

What shortcomings? So far we have a hypothetical complaint that some 
users will want to choose a different value. Right now they have the 
choice of continuing to not use relatime. Things are no worse for them 
than they were previously.

> > If there are actually users who want to be able to tune this 
> > per filesystem then I'm sure someone (possibly even me) will write code 
> > to support them, but right now it just sounds like features for the sake 
> > of some sense of aesthetic correctness.
> 
> A hard-wired global 24-hours constant is in no way superior to a
> per-mount tunable.  If we're going to do this we should do it in the
> best way we know, and we certainly should not lock ourselves into the
> inferior implementation for all time by exposing it to userspace.

I don't claim that it's superior, merely that it deals with all the use 
cases I've had to worry about and so is good enough. If it turns out 
that there are people in the real world who need the better version then 
I can write that code, but I'm not going to while it's a hypothetical.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
