Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYKINv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYKINv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYKINvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 08:51:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51278 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754788AbYKINvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:51:49 -0500
Date: Sun, 9 Nov 2008 14:44:22 +0100
From: Pavel Machek <pavel@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, ncunningham@crca.org.au, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
Message-ID: <20081109134422.GA1730@ucw.cz>
References: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org> <200810292211.49021.rjw@sisk.pl> <1225316715.18786.1.camel@nigel-laptop> <200810292307.26945.rjw@sisk.pl> <E1KvKql-0000dC-3M@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KvKql-0000dC-3M@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 00:53:19, Miklos Szeredi wrote:
> On Wed, 29 Oct 2008, Rafael J. Wysocki wrote:
> > In any case, the freezing of user space seems to be much simpler
> > than modifying all drivers to add suspend synchronization.
> 
> As I mentioned, we don't _have_ to modify all drivers.  It could start
> out by just modifying syscalls that result in calls to drivers.  That
> would be a 10-liner patch.

If you can solve current freezer vs. fuse in 10 lines, that would be
useful...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
