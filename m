Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZADEQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZADEQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 23:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZADEP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 23:15:56 -0500
Received: from phunq.net ([64.81.85.152]:36325 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751859AbZADEPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 23:15:55 -0500
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Sat, 3 Jan 2009 20:15:50 -0800
User-Agent: KMail/1.9.5
Cc: Jamie Lokier <jamie@shareable.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <495EDE04.5080703@gmail.com> <20090104031733.GB20929@shareable.org>
In-Reply-To: <20090104031733.GB20929@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901032015.51029.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 19:17, Jamie Lokier wrote:
> Justin P. Mattock wrote:
> > Thats some crazy stuff!! and just think most of it is
> > simply magnets.(but more complicated than that)
> > >One feature we are kicking around to make life easier for SELinux:
> > >sometimes the filesystem can run while SELinux is not running, and
> > >security labels will be wrong when SELinux re-enters the picture.  We
> > >have in mind to provide a persistent log of filesystem events that the
> > >security system can attach to on startup and find out what went on in
> > >its absence.
> > >
> > >  
> > That sounds nice:
> > 
> > find out what went on in
> > its absence.
> 
> That sounds like a feature Windows had for many years now, (since
> Windows 2000?).  It complements the Windows equivlant of
> dnotify/inotify/fsnotify.
> 
> It's used for file indexing too (think equivalent to Spotlight,
> Beagle, etc.), and other types of security scanning (think equivalent
> to Tripwire).
> 
> I wonder why the people writing file indexing tools for Linux never
> made a fuss about this.  Inotify is ok for indexing, but means quite a
> few minutes of intensive disk activity after each boot to rescan /home.

Actually they did.  It was a poke from Jos van den Oever, the Strigi
guy, that got me thinking about it, the security aspect came up later.

Regards,

Daniel
