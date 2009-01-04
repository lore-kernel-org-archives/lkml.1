Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZADDRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZADDRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZADDRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 22:17:42 -0500
Received: from mail2.shareable.org ([80.68.89.115]:51944 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZADDRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 22:17:41 -0500
Date: Sun, 4 Jan 2009 03:17:33 +0000
From: Jamie Lokier <jamie@shareable.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Message-ID: <20090104031733.GB20929@shareable.org>
References: <200812301935.49303.phillips@phunq.net> <200901021719.26680.phillips@phunq.net> <495EC040.2070905@gmail.com> <200901021903.24189.phillips@phunq.net> <495EDE04.5080703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495EDE04.5080703@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> Thats some crazy stuff!! and just think most of it is
> simply magnets.(but more complicated than that)
> >One feature we are kicking around to make life easier for SELinux:
> >sometimes the filesystem can run while SELinux is not running, and
> >security labels will be wrong when SELinux re-enters the picture.  We
> >have in mind to provide a persistent log of filesystem events that the
> >security system can attach to on startup and find out what went on in
> >its absence.
> >
> >  
> That sounds nice:
> 
> find out what went on in
> its absence.

That sounds like a feature Windows had for many years now, (since
Windows 2000?).  It complements the Windows equivlant of
dnotify/inotify/fsnotify.

It's used for file indexing too (think equivalent to Spotlight,
Beagle, etc.), and other types of security scanning (think equivalent
to Tripwire).

I wonder why the people writing file indexing tools for Linux never
made a fuss about this.  Inotify is ok for indexing, but means quite a
few minutes of intensive disk activity after each boot to rescan /home.

-- Jamie
