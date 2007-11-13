Return-Path: <linux-kernel-owner+w=401wt.eu-S1762177AbXKMUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177AbXKMUJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbXKMUJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:09:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757789AbXKMUJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:09:03 -0500
Date: Tue, 13 Nov 2007 12:07:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Philip Mucci <mucci@cs.utk.edu>, eranian@hpl.hp.com,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-Id: <20071113120728.4342e7d7.akpm@linux-foundation.org>
In-Reply-To: <20071113185924.GA22748@suse.de>
References: <20071107003454.GA13374@kroah.com>
	<20071109120627.60ec9ab4.akpm@linux-foundation.org>
	<20071109213829.GC28276@kroah.com>
	<p73abpl2654.fsf@bingen.suse.de>
	<20071113151718.GA3804@erda.amd.com>
	<4739C42F.8030208@redhat.com>
	<20071113175545.GD4319@frankl.hpl.hp.com>
	<53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
	<20071113185924.GA22748@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 10:59:24 -0800 Greg KH <gregkh@suse.de> wrote:

> On Tue, Nov 13, 2007 at 10:47:45AM -0800, Philip Mucci wrote:
> > Hi folks,
> >
> > Well, I can say the mood here at supercomputing'07 is pretty somber in 
> > regards to the latest exchange of messages regarding the perfmon patches. 
> 
> "somber"?
> 
> Why?
> 
> We (a number of the kernel developers) want to see the perfmon code make
> it into the kernel tree, unfortunatly, in the current state it is in,
> that's not going to happen.
> 
> Andi specified a way that this can happen, just refactor your patches
> into smaller bits that can be reviewed and applied.
> 
> If you, or anyone else has any questions about this, please let us know.
> So far, I have not seen any response to his message, so I'm guessing
> that the perfmon developers either are off working on this, or don't
> care.
> 
> And if they don't care, then yes, I agree with your "somber" feeling...
> 

Well...  Philip is (I assume) a numerical-computing guy and not a
kernel-developing guy (probably a wise choice).

He speaks for quite a few people - they have serious need for this feature
but they've had to scruff around with out-of-tree patches for years to get
it, and still there are problems.

I was hoping that after the round of release-and-review which Stephane,
Andi and I did about twelve months ago that we were on track to merge the
perfmon codebase as-offered.  But now it turns out that the sentiment is
that the code simply has too many bells-and-whistles to be acceptable.

My problem with that sentiment is that it is quite likely the case that
those bells-n-whistles are actually useful and needed features.  Perfmon
has been out there for quite a few years and the code which is in there
_should_ be in response to real-world in-the-field experience.  Such
requirements never go away.


So.  If what I am saying is correct then the best course of action would be
for Stephane to help us all to understand what these features are and why
we need them.  The ideal way in which to do this is

[patch] perfmon: core
[patch] perfmon: whizzy feature #1
[patch] perfmon: whizzy feature #2
[patch] perfmon: whizzy feature #3

etc.  Where the changelog in each whizzy-feature-n explains what it does,
why it does it and why our users need it.

Whatever happens, perfmon is so big and so old and has been out-of-tree for
so long that it's going to take a pile of work from lots of people to get
any of it landed.

