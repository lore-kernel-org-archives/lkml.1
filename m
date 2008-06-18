Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbYFTHci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbYFTHci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 03:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYFTHc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 03:32:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3617 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751192AbYFTHc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 03:32:28 -0400
Date: Wed, 18 Jun 2008 22:52:57 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jason Baron <jbaron@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, joe@perches.com,
       greg@kroah.com, nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] dynamic debug - core infrastructure
Message-ID: <20080618205257.GA4147@ucw.cz>
References: <20080613190039.GC8813@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613190039.GC8813@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is the core patch that implements a new dynamic debug infrastructure.
> 
> Each kernel sub-system seems to have its own way of dealing with debugging
> statements. Some of these methods include 'dprintk', 'pr_debug', 'dev_debug',
> 'DEBUGP'. There are also a myriad of ways of enabling these statements. Some
> require CONFIG_ parameters to be set, some provide /proc interfaces, while
> others require 'DEBUG' to be set in header files. Most of these methods also
> require kernel re-compiles in order to set the appropriate knobs.
> 
> I've attempted to standardize how how the kernel deals with debugging
> statements, both from the user as well as the kernel perspective. Why aren't
> these debug statements made into printk(KERN_DEBUG), and be done with it? The
> problem here is that 'dprintk', 'pr_debug', etc. were introduced b/c they
> are often provide too verbose a level of output, could potentially adversly
> affect system performance if they were always enabled, and they clutter up the
> system logs.

Its good that someone is finallu cleaning this up. Thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
