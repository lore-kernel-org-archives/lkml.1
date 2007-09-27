Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbXI0LXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbXI0LXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbXI0LXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:23:36 -0400
Received: from thunk.org ([69.25.196.29]:60927 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbXI0LXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:23:35 -0400
Date: Thu, 27 Sep 2007 07:23:16 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christer Weinigel <christer@weinigel.se>
Cc: David Newall <david@davidnewall.com>, Al Viro <viro@ftp.linux.org.uk>,
       Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070927112316.GC18346@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christer Weinigel <christer@weinigel.se>,
	David Newall <david@davidnewall.com>,
	Al Viro <viro@ftp.linux.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
	Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
	bunk@fs.tum.de, linux-kernel@vger.kernel.org
References: <20070919194559.36015307@the-village.bc.nu> <46F1A196.8060108@davidnewall.com> <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com> <20070926212408.6662231a@zoo.weinigel.se> <46FACCE0.2070005@davidnewall.com> <20070927092808.612c204b@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927092808.612c204b@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 09:28:08AM +0200, Christer Weinigel wrote:
> So the OpenBSD man page seems to be in the minority here.  Any portable
> code can not assume that CWD changes.  And changing the Linux behaviour
> now would be a rather big change which might break userspace.  And yes,
> there are applications that rely on this, I've used it when building
> software for cross compiling.  

Changing Linux behavior would violate the POSIX and SuSV2
specifications; the standards explicitly state that the working
directory will NOT change.  And standards adherance is important; we
break them only if we have a d*mn good reason.  And trying to make
chroot() something which it is not (i.e., a secure jail) is certainly
not a good enough reason.

Can we please end this thread now?  And can we put in a Kernel FAQ
saying that this is not something which is NOT up for discussion?

       	    	    		  	   - Ted
