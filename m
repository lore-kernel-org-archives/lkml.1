Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbZBVXX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbZBVXX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbZBVXTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:19:31 -0500
Received: from thunk.org ([69.25.196.29]:44242 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbZBVXT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:19:29 -0500
Date: Sun, 22 Feb 2009 18:19:14 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090222231914.GI17066@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
	Ric Wheeler <rwheeler@redhat.com>
References: <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <20090212212304.GA7935@duck.suse.cz> <499494E2.3060006@redhat.com> <20090213022336.GH6922@mini-me.lan> <20090222141532.GC1586@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222141532.GC1586@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 03:15:33PM +0100, Pavel Machek wrote:
> 
> Sounds like posix violation to
> me... '/sys/fsync_does_not_really_sync'?

It's as much a Posix violation as noatime.  :-)

> Perhaps it is better done at glibc level? Environment variables
> already mostly have semantics you want.....

Environment variables own't allow us to switch fsync's on and off
while the process is running, so that the system can run "safe" while
it is on AC mains, but "low power" when on battery.

      	    	       	    	   	   - Ted
