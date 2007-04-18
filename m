Return-Path: <linux-kernel-owner+w=401wt.eu-S1030295AbXDRW61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295AbXDRW61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXDRW61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:58:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbXDRW60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:58:26 -0400
Date: Wed, 18 Apr 2007 18:58:10 -0400
From: Dave Jones <davej@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kyle McMartin <kyle@canonical.com>, linux-kernel@vger.kernel.org,
       alan@redhat.com, bcollins@ubuntu.com, pjones@redhat.com
Subject: mkinitrd.  (was Re: [RFC] [PATCH] Allow overriding module parameters from kernel command_line)
Message-ID: <20070418225810.GB20204@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Neil Brown <neilb@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyle McMartin <kyle@canonical.com>, linux-kernel@vger.kernel.org,
	alan@redhat.com, bcollins@ubuntu.com, pjones@redhat.com
References: <20070418155552.GA3744@athena.road.mcmartin.ca> <20070418144512.14528b78.akpm@linux-foundation.org> <17958.40945.937891.44930@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17958.40945.937891.44930@notabene.brown>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 08:47:13AM +1000, Neil Brown wrote:
 
 > > Fixed by changing /etc/fstab and rebuilding initrd, but IMO rootfstype=
 > > should have worked.
 > 
 > I think these are both issues that should be solved by smarts in the
 > initrd.

This is getting away from the intent of Kyle's original patch
(Which I think is worthwhile fwiw, having recently hit the exact
 same sata_nv bug that prompted him to write it)

 > What we really need is a single reference implementation of "mkinitrd"
 > which each distro can fiddle with to their heart's content.  Then
 > sensible ideas like the above can be incorporated into the reference,
 > and all distros will ultimately pick them up.
 > 
 > But unfortunately I don't have the time to volunteer for this role...

The problem I see with such a 'one mkinitrd to rule them all', is that
it would suffer from the same thing that stopped any vendor stepping
up and getting behind hpa's klibc project...  Apathy due to "our current
stuff works, why would we throw it all away and start again"

It's a great idea in theory, in practise however, initrd construction
for every distro now contains years of custom hacks and workarounds
(that may not even be relevant on other distros).

Given the critical nature of mkinitrd (get something wrong, and your
system doesn't boot), unsurprisingly, people are reluctant to change
away from something they're familar with, unless there's a *really*
compelling reason.

	Dave

-- 
http://www.codemonkey.org.uk
