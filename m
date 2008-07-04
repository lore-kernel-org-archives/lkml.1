Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYGDJCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYGDJCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 05:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYGDJCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 05:02:01 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:42573 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752859AbYGDJCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 05:02:00 -0400
Date: Fri, 4 Jul 2008 17:59:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080704085910.GA9671@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>,
	Oliver Neukum <oliver@neukum.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>
References: <20080704063455.GA13999@digi.com> <200807040852.27809.oliver@neukum.org> <20080704065722.GA22420@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704065722.GA22420@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 08:57:22AM +0200, Uwe Kleine-K?nig wrote:
> Oliver Neukum wrote:
> > Am Freitag 04 Juli 2008 08:34:55 schrieb Uwe Kleine-K?nig:
> > > Hello,
> > >
> > > I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> > > the corresponding region the alphabetic ordering is broken.  Then I
> > > inteded to fix that up for a trivial patch.  Next was to check the rest
> > > of the file and there are so much misorderings that it's not sensible to
> > > choose the trivial path anymore as there are currently 114 entries out
> > > of order[1].
> > 
> > What good does alphabetic ordering? You'll grep it anyway.
> This is fine for me, too.  Then I suggest to remove the section
> 
> 	Note: For the hard of thinking, this list is meant to remain in alphabetical
> 	order. If you could add yourselves to it in alphabetical order that would be
> 	so much easier [Ed]
> 
> .  That's why I posted before spending time on writing a clever script.
> 
I always interpreted this to mean that the _entries_ are alphabetically
sorted, not the maintainers under each entry. IIRC, Alan has already
cleaned up most of the ordering of the entries through recent patches.

Historically the entries with multiple people listed have been in
decreasing order. Thus, the primary maintainer for a given entry is
listed first, with deputy maintainers following afterwards. Most places
where there are co-maintainers, there is still a single person who is the
main interface in to mainline, and it makes sense to have them listed
first. Re-ordering here would simply lead to confusion, or a lot of "send
this to xxx" mail. On the other hand, other entries with co-maintainers
tend to be more ad-hoc, so there doesn't seem to really be a good rule in
general. NETWORKING and KPROBES demonstrate both cases, as an example.
