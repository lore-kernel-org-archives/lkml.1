Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZBVKDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZBVKDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 05:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbZBVKCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 05:02:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbZBVKCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 05:02:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug #12610] sync-Regression in 2.6.28.2?
Date: Sun, 22 Feb 2009 11:02:09 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Federico Cuello <fedux@lugmen.org.ar>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       bugme-daemon@bugzilla.kernel.org, Greg KH <gregkh@suse.de>,
       stable@kernel.org
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.xTF.As0lJB@chimera> <20090221175646.GB3750@mit.edu>
In-Reply-To: <20090221175646.GB3750@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902221102.10579.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 February 2009, Theodore Tso wrote:
> On Sat, Feb 14, 2009 at 09:38:18PM +0100, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12610
> > Subject		: sync-Regression in 2.6.28.2?
> > Submitter	: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
> > Date		: 2009-01-27 9:35 (19 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123304977706620&w=4
> 
> This fix for this has landed in mainline post 2.6.29-rc5, as commit
> 2acf2c.  The deadlock is technically not a regression but it was made
> *much* more likely to show up because of commit 31a1266: ("mm:
> write_cache_pages cyclic fix, which show up in 2.6.28.1").  
> 
> Commit 3a4c68 in mainline backs up the change made in 31a1266, so you
> probably won't see this much after 2.6.28.6 (when 3a4c68 was
> backported to 2.6.28.y), but we should get commit 2acf2c pushed to
> 2.6.28.x and 2.6.27.y to completely solve the deadlock problem.

Thanks for the update.

I'll close the bug since it's fixed in the mainline.  Please tell Greg which
patches to put into the -stable kernels.

Thanks,
Rafael


> 
> 						- Ted
> 
> 


-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
