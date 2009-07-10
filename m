Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZGJVPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZGJVPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 17:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZGJVPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 17:15:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40102 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752073AbZGJVPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 17:15:10 -0400
Date: Fri, 10 Jul 2009 22:14:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       David Newall <davidn@davidnewall.com>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090710221435.05d50bc0@lxorguk.ukuu.org.uk>
In-Reply-To: <20090710133127.6839dc87@bike.lwn.net>
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<200907100023.48039.Martin@lichtvoll.de>
	<4A569D36.3060707@davidnewall.com>
	<200907102049.12427.Martin@lichtvoll.de>
	<20090710133127.6839dc87@bike.lwn.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The FAT patents *have* been tested, invalidated, and then revalidated.
> Yes, they might still be invalid - I believe they are.  This helps a
> Linux user whose products have been seized at the US border exactly
> how? 

The same way as one who shipped mp3 software.

Of course they can simply remove the code that concerns them as companies
*already do*. They have specialists for this, experts who know the very
complex field of import and export regulation.

> SCO is a very different story, though.  Copyright infringement is
> usually pretty easy to avoid - just do your own work.  Patent
> infringement happens regardless of how original your work is.

Actually this is changing, large corporations stealing photographic
images and the threatening to sue the original photographer is becoming
rather common. I'm sure the same will happen in other fields too. SCO
probably did it by accident, but folks will do it deliberately too.

> I have a lot of sympathy for Alan's assertion that we can't muck up our
> upstream code with hackarounds for every bit of legal obnoxiousness we
> encounter.  But outright refusal of things like patent workarounds does
> not help us either.  Linux is a pragmatic system; somehow, I believe,
> we can find a way to minimize our patent hassles without messing up the
> system as a whole.

If you don't believe VFAT is permitted in your shipping locale you turn
it off (actually you cut the code from your source tar before build).
Utterly routine practice every day for companies shipping product into
the USA. Happens with tons of other open source software that isn't
permitted in the USA.

The pragmatic approach would be to either avoid the patent without
breaking stuff (which Tridge hasn't managed, although maybe one day he
might), or to produce something which doesn't break stuff, is reliable,
meets our quality goals but which is alternative and clearly presented as
an alternative - such as Tridge's shortname creating tridgefat variant,
which at least didn't randomly explode users data in new and novel ways.
It still needs to be an alternative not a replacement for the real thing.

Alan
