Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYAPLto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYAPLto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYAPLtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:49:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42760 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751830AbYAPLte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:49:34 -0500
Date: Wed, 16 Jan 2008 12:49:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Phillips <phillips@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
       Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
	fsck)
Message-ID: <20080116114940.GC22460@elf.ucw.cz>
References: <200801090022.55589.a1426z@gawab.com> <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu> <20080113171916.GB4132@ucw.cz> <20080113174125.5f39ac64@lxorguk.ukuu.org.uk> <20080115201653.GA5639@elf.ucw.cz> <4d47a5d10801151744t378ecdcbj1c326181b4360452@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d47a5d10801151744t378ecdcbj1c326181b4360452@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Along with this effort, could you let me know if the world actually
> cares about online fsck?  

I'm not the world's spokeperson (yet ;-).

> Now we know how to do it I think, but is it
> worth the effort.

ext3's "lets fsck on every 20 mounts" is good idea, but it can be
annoying when developing. Having option to fsck while filesystem is
online takes that annoyance away.

So yes, it would be very useful for me...

For long-running servers, this may be less of a problem... but OTOH
their filesystems are not checked at all as long servers are
online... so online fsck is actually important there, too, but for
other reasons.

So yes, it is very useful for world.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
