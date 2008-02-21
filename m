Return-Path: <linux-kernel-owner+w=401wt.eu-S935233AbYBUWTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935233AbYBUWTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760867AbYBUWTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:19:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40862 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754703AbYBUWTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:19:34 -0500
Date: Thu, 21 Feb 2008 23:19:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org
Subject: Re: power_state: remove it from usb
Message-ID: <20080221221950.GA25977@elf.ucw.cz>
References: <20080221130145.GA3789@elf.ucw.cz> <Pine.LNX.4.44L0.0802211648530.2114-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802211648530.2114-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-02-21 16:50:36, Alan Stern wrote:
> On Thu, 21 Feb 2008, Pavel Machek wrote:
> 
> > power_state is scheduled for removal, and it is used only write-only
> > by USB. Remove it.
> 
> Unfortunately some of the things you changed turn out not to be 
> write-only.  (You also missed a usage of power.power_state in a 
> comment!)  

I might have missed comments, but where I missed read? It compiled
after I removed the field from the core...?

> I'll post a more complete patch soon.		

Thanks!
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
