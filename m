Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXFLOlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXFLOlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXFLOlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:41:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1301 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753212AbXFLOlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:41:13 -0400
Date: Sun, 10 Jun 2007 18:27:47 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Tweedie <sct@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
Message-ID: <20070610182746.GA4272@ucw.cz>
References: <46680BB8.50404@rtr.ca> <20070607084142.42583639.akpm@linux-foundation.org> <46682BE7.6080802@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46682BE7.6080802@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Did this succeed?  If the application is still 
> >truncating that file, the
> >umount should have failed.
> 
> Actually, what I expect to happen is for the remount,ro
> to block  until the file deletion completes.  But it 
> doesn't.
> 
> Once a f/s is read-only, there should be NO writing to 
> it.  Right?

Linux happily writes to filesystems mounted read-only. It will replay
journal on them.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
