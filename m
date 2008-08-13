Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYHMHs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYHMHs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYHMHrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:47:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37108 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbYHMHrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:47:51 -0400
Date: Wed, 13 Aug 2008 09:08:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Renninger <trenn@suse.de>
Cc: Milan Broz <mbroz@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Greg Kroah-Hartman <gregkh@novell.com>, stable@kernel.org
Subject: Re: 2.6.27-rc1 and 2.6.26.1: critical thermal shutdown on thinkpad
	x60 (bisected)
Message-ID: <20080813070818.GC1813@elf.ucw.cz>
References: <20080806090246.GA1572@elf.ucw.cz> <48A1A4F6.9080706@redhat.com> <48A1B0CB.9050908@redhat.com> <200808121801.21374.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808121801.21374.trenn@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-12 18:01:18, Thomas Renninger wrote:
> On Tuesday 12 August 2008 17:48:27 Milan Broz wrote:
> > >>>> yes. maybe some userspace tool controlling frequency is involved, no
> > >>>> idea yet. But it is 2.6.26 tree for sure.
> > >>>
> > >>> So it definitely is in 2.6.26.2, and it definitely is in 2.6.26?
> > >
> > > The bug is _not_ in 2.6.26, it was introduced in 2.6.26.1.
> > >
> > > The problem is, that now the CPU frequency doesn't decrease at some
> > > temperature level and fan is unable to cool it properly.
> Hmm, the machine should still not shut down. We need the virtual
> passive trip point...

Won't help here.

We already do have real passive trip point on the other thermal zone,
and the zone that actually forces shutdown goes 95->128C instantly
(see that DSDT). Virtual passive trip point at 115C will not help
anything.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
