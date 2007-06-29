Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbXGDRCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbXGDRCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 13:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbXGDRCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 13:02:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1607 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753621AbXGDRCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 13:02:22 -0400
Date: Fri, 29 Jun 2007 18:06:58 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070629180658.GA3895@ucw.cz>
References: <20070626230756.519733902@suse.de> <20070626165202.bfe8e6df.akpm@linux-foundation.org> <20070627022403.GB14656@suse.de> <20070626194700.5b0ff477.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626194700.5b0ff477.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > so...  where do we stand with this?  Fundamental, irreconcilable
> > > differences over the use of pathname-based security?
> > > 
> > There certainly seems to be some differences of opinion over the use
> > of pathname-based-security.
> 
> I was refreshed to have not been cc'ed on a lkml thread for once.  I guess
> it couldn't last.
> 
> Do you agree with the "irreconcilable" part?  I think I do.
> 
> I suspect that we're at the stage of having to decide between
> 
> a) set aside the technical issues and grudgingly merge this stuff as a
>    service to Suse and to their users (both of which entities are very
>    important to us) and leave it all as an object lesson in
>    how-not-to-develop-kernel-features.

If this is merged, suse is stuck with technically inferior solution
forever. This may please parts of suse, but not our users.

If this is not merged, suse will [have to] work with selinux people to
come up with friendlier userland tools/selinux improvements. (We
already had discussions with vojtech about a way to add path-based
aspects to selinux, and selinux people already offered to add 'new
file label is function of directory label and new name' support, which
addresses lots of reasons for AA).

Actually, there's a middle way. Merging only 'pass vfsmounts down'
parts will make AA self contained enough that suse will not go crazy
while trying to maintain it, but will have good enough incentive to
work with selinux people on something better.

							Pavel
					(not speaking for suse,
					as usual).
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
