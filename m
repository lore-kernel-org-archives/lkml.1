Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZKTK5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZKTK5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZKTK53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:57:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50944 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZKTK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:57:28 -0500
Date: Fri, 20 Nov 2009 11:57:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 2/3] staging/dream: add missing include files
Message-ID: <20091120105726.GH11212@elf.ucw.cz>
References: <20091101222717.GB20740@elf.ucw.cz>
 <20091119225602.GC18710@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119225602.GC18710@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-11-19 14:56:02, Greg KH wrote:
> On Sun, Nov 01, 2009 at 11:27:17PM +0100, Pavel Machek wrote:
> > Add missing files/includes neccessary for Dream compilation.
> >     
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> This patch includes a file that is not in the drivers/staging/
> directory, and it does this Kconfig mess:

Oops, sorry. That one escaped me. I'll submit fixed version.

> > +config GENERIC_GPIO
> > +	bool
> > +	default y
> 
> Which breaks the i386 build.  Don't force on a general config option
> like this, that's not nice at all :(

Ok, I should figure out how to limit it to arch-msm.

> So I'll not apply this one, and the 3/3 patch.

Where can I get the tree to diff against?
gregkh-08-staging-2.6.32-rc7-git4.patch just reverts everything.

I guess I can extract it from
://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/series ...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
