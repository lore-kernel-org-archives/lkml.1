Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbZJIUiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbZJIUiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761419AbZJIUip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:38:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60104 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760694AbZJIUio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:38:44 -0400
Date: Fri, 9 Oct 2009 22:38:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: staging: where to put system-wide includes
Message-ID: <20091009203802.GD2040@elf.ucw.cz>
References: <20091008112817.GA28916@elf.ucw.cz>
 <20091008184027.GA5890@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008184027.GA5890@infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-08 14:40:27, Christoph Hellwig wrote:
> On Thu, Oct 08, 2009 at 01:28:18PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > In staging, I need some includes that will become "system-wide" at the
> > end.
> > 
> > Is it acceptable to create drivers/staging/include/linux (and
> > friends), and then use -I magic to include those headers?
> 
> If you need system-wide inclusions it's pretty good sign that what
> you add is not a simple driver and thus should not just go into the
> staging tree.  Given that you're a long-timer kernel hackers what's the
> problem with getting your code fully up to kernel standards anyway?

Well, it is not exactly my code -- I'm trying to merge HTC Dream
support. Problem with "simply cleaning it up" is that its 122Kloc.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
