Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZGYWXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZGYWXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 18:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZGYWXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 18:23:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55623 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbZGYWXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 18:23:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Paris <eparis@redhat.com>
Subject: Re: inotify regression, missing events
Date: Sun, 26 Jul 2009 00:23:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
References: <1247328127.4003.6.camel@wing-commander> <1247487669.14981.18.camel@quest> <1247492599.3068.19.camel@localhost>
In-Reply-To: <1247492599.3068.19.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907260023.36398.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 July 2009, Eric Paris wrote:
> On Mon, 2009-07-13 at 13:21 +0100, Scott James Remnant wrote:
> > On Sat, 2009-07-11 at 07:50 -0400, Eric Paris wrote:
> > 
> > > On Sat, 2009-07-11 at 17:02 +0100, Scott James Remnant wrote:
> > > > Looks like there's a regression with inotify since the rewrite to use
> > > > fanotify.  Events are simply missing and not being delivered to
> > > > userspace.
> > > > 
> > > > Here's a simple test case, just compile and run it:
> > > 
> > > I bet I know exactly what it is (notification.c tail merge code isn't
> > > comparing filename only inode+mask) but I'm walking out of the house.
> > > I'll try my theory later tonight and post a patch.
> > > 
> > > Stupid Eric, Stupid.
> > > 
> > In other words, when the second deleted-file-in-a-directory event comes
> > through, it gets ignored because there's already a
> > "deleted-file-in-a-directory" event for that directory?
> 
> Yes, and I sent a patch but apparent screwed up the --smtp-server option
> so it never got out.  Resending.  Sorry.....

Did the patch reach Linus eventually?

Rafael
