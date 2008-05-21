Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbYEULQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbYEULQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbYEULQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:16:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43891 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbYEULQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:16:44 -0400
Date: Wed, 21 May 2008 13:16:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Oliver Hartkopp <oliver@hartkopp.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
Message-ID: <20080521111637.GA5416@ucw.cz>
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4819050C.9060800@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-04-30 16:47:24, H. Peter Anvin wrote:
> Oliver Hartkopp wrote:
> >Hi all,
> >
> >i wonder about the Kernel naming convention in the 
> >merge phase before
> >the -rc1 is officially tagged by Linus.
> >
> >Won't it be more precisely to name the current snapshot
> >2.6.26-merge-git16 instead of 2.6.25-git16?
> >
> >It is not that i would suggest to have a new git tag in 
> >this merge phase but only the Makefile should be 
> >changed at the beginning of this phase to identify the 
> >ongoing work for the 2.6.26:
> >
> >------
> >diff --git a/Makefile b/Makefile
> >index d3634cd..b8c85a4 100644
> >--- a/Makefile
> >+++ b/Makefile
> >@@ -1,8 +1,8 @@
> >VERSION = 2
> >PATCHLEVEL = 6
> >-SUBLEVEL = 25
> >-EXTRAVERSION =
> >-NAME = Funky Weasel is Jiggy wit it
> >+SUBLEVEL = 26
> >+EXTRAVERSION = -merge
> >+NAME = unnamed
> >
> ># *DOCUMENTATION*
> ># To see a list of typical targets execute "make help"
> >------
> >
> >Introducing the new '-merge' version _that_ early helps 
> >to avoid the version confusion in /lib/modules and also 
> >allows people to work with kernel version depended 
> >stuff in a very early phase.
> >
> 
> And it'll break all the robotic stuff again.
> 
> Foo-gitX has always been a development snapshot which 
> *follows* Foo.

Well, unfortunately its not there in the makefile, so you can't tell
2.6.25 from 2.6.26-rc0...

Would 'rc0' make robots happy?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
