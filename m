Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZJQS0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZJQS0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 14:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZJQS0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 14:26:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45605 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZJQS0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 14:26:20 -0400
Date: Sat, 17 Oct 2009 20:26:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: staging: where to put system-wide includes
Message-ID: <20091017182618.GD16532@elf.ucw.cz>
References: <20091008112817.GA28916@elf.ucw.cz>
 <20091008150010.GA11977@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008150010.GA11977@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-08 08:00:10, Greg KH wrote:
> On Thu, Oct 08, 2009 at 01:28:18PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > In staging, I need some includes that will become "system-wide" at the
> > end.
> > 
> > Is it acceptable to create drivers/staging/include/linux (and
> > friends), and then use -I magic to include those headers?
> 
> No, keep them in the subdir for the drivers you are adding please and
> reference them by the location directly, no -I magic.

That will make moving drivers to final place "interesting", but I'll
do as you wish.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
