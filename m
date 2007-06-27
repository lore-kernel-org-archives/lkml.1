Return-Path: <linux-kernel-owner+w=401wt.eu-S1762805AbXF0TcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbXF0TcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXF0TcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:32:11 -0400
Received: from eastrmmtao103.cox.net ([68.230.240.9]:38922 "EHLO
	eastrmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760835AbXF0TcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:32:09 -0400
Date: Wed, 27 Jun 2007 15:32:07 -0400
From: Chris Shoemaker <c.shoemaker@cox.net>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, josh@kernel.org
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
Message-ID: <20070627193207.GA1219@pe.Belkin>
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com> <20070627180552.GA746@pe.Belkin> <1182968229.8970.124.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182968229.8970.124.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 11:17:09AM -0700, Josh Triplett wrote:
> On Wed, 2007-06-27 at 14:05 -0400, Chris Shoemaker wrote:
> > On Wed, Jun 27, 2007 at 10:59:20AM -0700, Josh Triplett wrote:
> > > +Do not leave trailing whitespace at the ends of lines.  Some editors with
> > > +"smart" indentation will insert whitespace at the beginning of new lines as
> > > +appropriate, so you can start typing the next line of code right away.
> > > +However, some such editors do not remove the whitespace if you end up not
> > > +putting a line of code there, such as if you leave a blank line.  As a result,
> > > +you end up with lines containing trailing whitespace.
> > > +
> > > +Git will warn you about patches that introduce trailing whitespace, and can
> > > +optionally strip the trailing whitespace for you; however, if applying a series
> > > +of patches, this may make later patches in the series fail by changing their
> > > +context lines.
> > 
> > What I'd really like to see is, _why_ is trailing whitespace
> > considered harmful?  Something about MUAs not preserving it or
> > something?
> 
> When the trailing whitespace later disappears, that change shows up in
> diffs, and since you can't see the whitespace difference, it just looks
> like a mysterious change until you check it more closely.  

Okay, but it seems like this is more of an argument that diffs
containing lines that change only the trailing whitespace are
considered harmful.  I buy that, but I don't see why it follows that
new code shouldn't have any trailing whitespace at all.

> It also introduces gratuitous conflicts and other such annoyances.

I don't get this part.  Only changes can create conflicts.  Are there
some editors (or MUAs) that change trailing whitespace without being
told to?  (And I'm not even talking about your warning about conflicts
created by applying stripped versions of early patches in a series -
that's just self-inflicted pain.)

-chris
