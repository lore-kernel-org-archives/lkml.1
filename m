Return-Path: <linux-kernel-owner+w=401wt.eu-S1763295AbXF1Oxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763295AbXF1Oxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbXF1OxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:53:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3711 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755969AbXF1OxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:53:18 -0400
Date: Thu, 28 Jun 2007 14:53:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
Message-ID: <20070628145308.GD5339@ucw.cz>
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620210343.GQ21478@ftp.linux.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ... or, alternatively, add a subfield to the first field (which would
> > entail escaping whatever separator we choose):
> > 
> > /dev/md6 /export ext3 rw,data=ordered 0 0
> > /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
> > /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
> 
> Hell, no.  The first field is in principle impossible to parse unless
> you know the fs type.
> 
> How about making a new file with sane format?  From the very

Well, what about /sysfs, with its one value per file rule?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
