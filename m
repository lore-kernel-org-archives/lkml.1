Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbZADNFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbZADNFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZADNEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:04:55 -0500
Received: from thunk.org ([69.25.196.29]:43427 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbZADNEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:04:54 -0500
Date: Sun, 4 Jan 2009 08:04:46 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jamie Lokier <jamie@shareable.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Message-ID: <20090104130446.GA17558@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jamie Lokier <jamie@shareable.org>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <200901021719.26680.phillips@phunq.net> <495EC040.2070905@gmail.com> <200901021903.24189.phillips@phunq.net> <495EDE04.5080703@gmail.com> <20090104031733.GB20929@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104031733.GB20929@shareable.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 03:17:33AM +0000, Jamie Lokier wrote:
> Justin P. Mattock wrote:
> > >One feature we are kicking around to make life easier for SELinux:
> > >sometimes the filesystem can run while SELinux is not running, and
> > >security labels will be wrong when SELinux re-enters the picture.  We
> > >have in mind to provide a persistent log of filesystem events that the
> > >security system can attach to on startup and find out what went on in
> > >its absence.
> > >
> That sounds like a feature Windows had for many years now, (since
> Windows 2000?).  It complements the Windows equivlant of
> dnotify/inotify/fsnotify.

Arguably you want to do this in the VFS layer, not in the low-level
filesystem level if you want most applications to adopt it.

> It's used for file indexing too (think equivalent to Spotlight,
> Beagle, etc.), and other types of security scanning (think equivalent
> to Tripwire).

Eric Paris has a patch he's been proposing for a while now for a new
notify mechanism designed for anti-virus scanners...

						- Ted
