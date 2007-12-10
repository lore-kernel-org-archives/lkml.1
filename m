Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbXLKN6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbXLKN6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXLKN62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:58:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1298 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752209AbXLKN62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:58:28 -0500
Date: Mon, 10 Dec 2007 16:37:37 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Mike McGrath <mmcgrath@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071210163736.GA6107@ucw.cz>
References: <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205144934.GL7259@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-12-05 09:49:34, Theodore Tso wrote:
> On Wed, Dec 05, 2007 at 08:26:19AM -0600, Mike McGrath wrote:
> >
> > Ok, whats going on here is an issue with how the smolt RPM installs the 
> > UUID and how Fedora's Live CD does an install.  It's a complete false alarm 
> > on the kernel side, sorry for the confusion.
> 
> BTW, You may be better off using "uuidgen -t" to generate the UUID in
> the smolt RPM, since that will use 12 bits of randomness from
> /dev/random, plus the MAC, address and timestamp.  So even if there is
> zero randomness in /dev/random, and the time is January 1, 1970, at
> least the MAC will contribute some uniqueness to the UUID.

I thought that /dev/random blocks when 0 entropy is available...? I'd
expect uuid generation to block, not to issue duplicates.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
