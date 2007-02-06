Return-Path: <linux-kernel-owner+w=401wt.eu-S1030602AbXBFXrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030602AbXBFXrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030604AbXBFXrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:47:14 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:26693 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030601AbXBFXrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:47:13 -0500
Date: Tue, 6 Feb 2007 15:41:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-Id: <20070206154146.c62012b4.randy.dunlap@oracle.com>
In-Reply-To: <1170804983.29759.1051.camel@pmac.infradead.org>
References: <1170801484.29759.1000.camel@pmac.infradead.org>
	<Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
	<1170803515.29759.1032.camel@pmac.infradead.org>
	<Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
	<1170804983.29759.1051.camel@pmac.infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Feb 2007 23:36:23 +0000 David Woodhouse wrote:

> On Tue, 2007-02-06 at 15:28 -0800, Linus Torvalds wrote:
> > (Example: I don't want to see IPV6 questions if IPV6 is off, BUT I might 
> > still want to be able to see the question about NFSv8.1, which only works 
> > on top of IPV6. I might not even *know* I want IPV6, but I know my company 
> > uses NFSv8.1, so I say "yes"). 
> 
> (Quoting very sparsely but I think honestly -- I think the above is the
> essence of what you were saying).
> 
> Actually it doesn't have to be that much of a problem if the config
> stuff is laid out sensibly, as Ingo mentioned earlier. Those IPv6
> options you don't want to see are likely to be all in an 'IPv6' submenu
> of the networking stuff which nobody forces you to visit. Yet
> 'NFSv8.1' (*shudder*) would be elsewhere under networked file systems,
> or some suboption of NFS, and you'd see it just fine.
> 
> > And I realize that was a contrieved example, but there are *real* examples 
> > of this in the kernel today. I may well know that I want 802.11 WEP 
> > encryption, for example, but I sure as hell had *no* clue that it requires 
> > ARC4.
> 
> Again, if you don't care about crypto then you're unlikely to be delving
> in the crypto menus. Nobody forces you to go there. But when you look at
> the greyed-out WEP option and you click on it and it tells you "You need
> ARC4 for this. Do you want me to turn it on for you?" (or whatever), you
> get what you wanted.
> 
> Really, if our config is set up in sensible submenus (as in general it
> _is_), the "see everything" behaviour really isn't bad.

Well, there's layout and then there's the tool(s).

Besides this select business, Bill (or someone :) mentioned a feature
that I requested about 8 months ago:  the ability to disable or enable
groups of drivers at one swoop.  And Matt has made some good
scripting suggestions.

For layout, we may not all agree on that part either.  :)
It's quite subjective.  E.g., I made/submitted a patch maybe 1 year
ago that tried to put all video graphics (frame buffer, AGP, DRM/DRI,
etc.) into one localized place in the menu structure.
OK, perhaps I wasn't persistent enough, but no one was interested
in it.  (That probably just means that config menus are low priority.)


---
~Randy
