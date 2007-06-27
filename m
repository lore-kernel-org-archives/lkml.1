Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbXF0SRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbXF0SRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbXF0SRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:17:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57511 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152AbXF0SRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:17:22 -0400
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Chris Shoemaker <c.shoemaker@cox.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, josh@kernel.org
In-Reply-To: <20070627180552.GA746@pe.Belkin>
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
	 <20070627180552.GA746@pe.Belkin>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 11:17:09 -0700
Message-Id: <1182968229.8970.124.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 14:05 -0400, Chris Shoemaker wrote:
> On Wed, Jun 27, 2007 at 10:59:20AM -0700, Josh Triplett wrote:
> > +Do not leave trailing whitespace at the ends of lines.  Some editors with
> > +"smart" indentation will insert whitespace at the beginning of new lines as
> > +appropriate, so you can start typing the next line of code right away.
> > +However, some such editors do not remove the whitespace if you end up not
> > +putting a line of code there, such as if you leave a blank line.  As a result,
> > +you end up with lines containing trailing whitespace.
> > +
> > +Git will warn you about patches that introduce trailing whitespace, and can
> > +optionally strip the trailing whitespace for you; however, if applying a series
> > +of patches, this may make later patches in the series fail by changing their
> > +context lines.
> 
> What I'd really like to see is, _why_ is trailing whitespace
> considered harmful?  Something about MUAs not preserving it or
> something?

When the trailing whitespace later disappears, that change shows up in
diffs, and since you can't see the whitespace difference, it just looks
like a mysterious change until you check it more closely.  It also
introduces gratuitous conflicts and other such annoyances.

- Josh Triplett


