Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbXFDNKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbXFDNKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXFDNKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:10:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36045 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbXFDNKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:10:07 -0400
Date: Mon, 4 Jun 2007 15:10:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: A kexec approach to hibernation
Message-ID: <20070604131000.GD1971@elf.ucw.cz>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl> <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz> <20070604122054.GB26615@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604122054.GB26615@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-06-04 13:20:54, Matthew Garrett wrote:
> On Mon, Jun 04, 2007 at 12:46:21PM +0200, Pavel Machek wrote:
> 
> > sync is perfectly safe way of telling the fs to store data on disk.
> 
> On disk, yes. On the filesystem, no. It's valid for the data to be left 
> in the journal, for instance.

Yep... then grub needs to grok the journal. It does for ext3, IIRC.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
