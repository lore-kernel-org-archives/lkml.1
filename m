Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYBDJDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYBDJDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 04:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYBDJDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 04:03:04 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:20174 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753322AbYBDJDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 04:03:02 -0500
Date: Mon, 4 Feb 2008 18:02:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh <linux-sh@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] SH/Dreamcast - fix regressions, whitespace and memory leaks in Maple Bus driver
Message-ID: <20080204090203.GA28102@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1202068847.6262.7.camel@localhost.localdomain> <20080204011034.GA22021@linux-sh.org> <1202113424.6489.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202113424.6489.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 08:23:44AM +0000, Adrian McMenamin wrote:
> 
> On Mon, 2008-02-04 at 10:10 +0900, Paul Mundt wrote:
> > On Sun, Feb 03, 2008 at 08:00:47PM +0000, Adrian McMenamin wrote:
> > > From: Adrian McMenamin
> > > 
> > This is useless if you are submitting the patch, especially if you're
> > missing a mail address.
> > 
> 
> >From Documentation/SubmittingPatches
> 
> The canonical patch message body contains the following:
>   * 
>   *   - A "from" line specifying the patch author.
>   * 
> 
Which doesn't invalidate the missing address problem, and the fact that
you are _already_ in the from line.

> > > This patch fixes the regression noted here:
> > > http://lkml.org/lkml/2008/1/26/189 as well as whitespace issues in the
> > > previous commit of this driver and the memory leaks noted here:
> > > http://lkml.org/lkml/2008/2/2/143 (as well as one or two other minor
> > > cleanups).
> > > 
> > The subject notes 3 specific things that are being addressed, but you've
> > rolled this all in to one patch which makes it utterly impossible to
> > figure out what you're actually fixing. At the very least, split this in
> > to 3 different patches, each dealing with one of the things noted in the
> > subject. The fact that regressions is plural also suggests you may want
> > to split this down in to smaller patches that deal with specific
> > regressions if they are not directly related.
> 
> What would be the point of submitting patches of broken code just to
> remove the whitespace your previous commit added to all the lines?
> 
My previous commit was directly from _your_ patch, given that your
patches have a history of whitespace damage, this doesn't seem like much
of a stretch. It's true I neglected to run it through checkpatch, I'll be
more careful with that in the future when applying patches from certain
parties.

The point of submitting a series of patches is so that it's obvious
_what_ you are changing. Lumping it in with the whitespace changes just
makes it impossible to read, as GregKH also hinted at when trying to
figure out specifically what you were fixing. Since your patch splits up
logically in to different components, it makes sense to split the patch
up in to a series that makes it obvious. I'm not sure why this needs to
be spelled out for you.
