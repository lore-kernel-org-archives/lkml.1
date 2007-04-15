Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbXDOT6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbXDOT6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXDOT6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:58:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3840 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753532AbXDOT5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:57:40 -0400
Date: Sun, 15 Apr 2007 18:49:29 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Phillip Susi <psusi@cfl.rr.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       joern@lazybastard.org, tytso@mit.edu
Subject: Re: Add a norecovery option to ext3/4?
Message-ID: <20070415184929.GC10097@ucw.cz>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com> <461BDD48.2000904@cfl.rr.com> <461BE2FB.5090101@redhat.com> <461D407C.3030706@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461D407C.3030706@tmr.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >You might not damage the underlying filesystem, but you 
> >could sure go
> >off in the weeds trying to read it, if you stumbled 
> >upon some
> >half-updated metadata... so while it may be safe for 
> >the filesystem, I'm
> >not convinced that it's safe for the host reading the 
> >filesystem.
> >
> Exactly. If the data are protected you can use other 
> software to access it. For ext3 an explicit ext2 mount 
> might do it... 

It does not :-(. dirty ext3 is marked incompatible with ext2.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
