Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbYHNU00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbYHNU00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYHNU0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:26:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56150 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbYHNU0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:26:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Date: Thu, 14 Aug 2008 22:29:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
References: <48A36838.3050309@hp.com> <200808141814.43484.rjw@sisk.pl> <48A485A8.8010803@hp.com>
In-Reply-To: <48A485A8.8010803@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808142229.28624.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 of August 2008, Alan D. Brunelle wrote:
> Rafael J. Wysocki wrote:
> > On Thursday, 14 of August 2008, Alan D. Brunelle wrote:
> >> I ran into this trying 2.6.27-rc3 today:
> >>
> >> [6.461876] kernel BUG at mm/vmalloc.c:217!
> >>
> >> (full boot log attached)
> >>
> >> I bisected it to:
> >>
> >> git-bisect bad 1c89ac55017f982355c7761e1c912c88c941483d
> >>
> >> which is:
> >>
> >> commit 1c89ac55017f982355c7761e1c912c88c941483d
> >> Merge: 88fa08f... b1b135c...
> >> Author: Linus Torvalds <torvalds@linux-foundation.org>
> >> Date:   Tue Aug 12 08:40:19 2008 -0700
> >>
> >>     Merge
> >> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus
> > 
> > This is a merge commit that introduced several changes into the
> > kernel.  It would be helpful to search through these changes.
> 
> I came in this morning, and did a 'git bisect reset' and 'git pull'
> built, and everything booted fine. I don't know if some fix came in for
> something else, or if the problem got "hidden" (some sort of timing
> thing, so the problem still lurks). If you feel it's important to track
> this down, if you could give me instructions on how to break apart that
> one merge, I could then try individual kernels from there...

I have created a Bugzilla entry at
http://bugzilla.kernel.org/show_bug.cgi?id=11342
for this problem.  I'll close it now, but please reopen if if the problem
reappears.

Thanks,
Rafael
