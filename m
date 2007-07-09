Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbXGIOCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbXGIOCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXGIOCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:02:35 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:39591 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbXGIOCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:02:35 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Hibernation Redesign
Date: Mon, 9 Jul 2007 16:02:26 +0200
User-Agent: KMail/1.9.7
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707081737.21932.a1426z@gawab.com> <87k5taw5vc.fsf@jbms.ath.cx> <20070709134522.GA3216@elf.ucw.cz>
In-Reply-To: <20070709134522.GA3216@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707091602.27312.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 9. Juli 2007 schrieb Pavel Machek:
> Hi!
> 
> > >> This approach eliminates the need for the freezer, as it would make
> > >> hibernate look a lot a bit like suspend to ram from the perspective of
> > >> the "old" kernel (the kernel being hibernated), as the hibernate
> > >> operation itself would be completely atomic from the perspective of the
> > >> "old" kernel.  That is not to say, of course, that any code paths would
> > >> actually be shared, or that the drivers would do the same things
> > >> (because they probably would not).
> > 
> > > Well it basically is suspend to RAM with the additional step that a
> > > new kernel gets booted and writes out the data from RAM to disk then
> > > shuts down.
> > 
> > There is the key difference, though, that the drivers should do rather
> > different things.  In particular, rather than place the hardware in a
> > low-power mode, it should place it in some state such that the new
> > kernel being loaded can handle it.
> 
> Actually, when current kernel restores the snapshot... driver
> requirements seem to be pretty similar. So that should not be a big
> problem.

Hm, once the new kernel is booted, this decision is irrevocable, isn't it?
Is there any way to deal with errors by handing control back?

	Regards
		Oliver

