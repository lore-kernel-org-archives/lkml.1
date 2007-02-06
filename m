Return-Path: <linux-kernel-owner+w=401wt.eu-S1030582AbXBFXga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030582AbXBFXga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030578AbXBFXga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:36:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43729 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030584AbXBFXg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:36:28 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
References: <1170801484.29759.1000.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
	 <1170803515.29759.1032.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 23:36:23 +0000
Message-Id: <1170804983.29759.1051.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 15:28 -0800, Linus Torvalds wrote:
> (Example: I don't want to see IPV6 questions if IPV6 is off, BUT I might 
> still want to be able to see the question about NFSv8.1, which only works 
> on top of IPV6. I might not even *know* I want IPV6, but I know my company 
> uses NFSv8.1, so I say "yes"). 

(Quoting very sparsely but I think honestly -- I think the above is the
essence of what you were saying).

Actually it doesn't have to be that much of a problem if the config
stuff is laid out sensibly, as Ingo mentioned earlier. Those IPv6
options you don't want to see are likely to be all in an 'IPv6' submenu
of the networking stuff which nobody forces you to visit. Yet
'NFSv8.1' (*shudder*) would be elsewhere under networked file systems,
or some suboption of NFS, and you'd see it just fine.

> And I realize that was a contrieved example, but there are *real* examples 
> of this in the kernel today. I may well know that I want 802.11 WEP 
> encryption, for example, but I sure as hell had *no* clue that it requires 
> ARC4.

Again, if you don't care about crypto then you're unlikely to be delving
in the crypto menus. Nobody forces you to go there. But when you look at
the greyed-out WEP option and you click on it and it tells you "You need
ARC4 for this. Do you want me to turn it on for you?" (or whatever), you
get what you wanted.

Really, if our config is set up in sensible submenus (as in general it
_is_), the "see everything" behaviour really isn't bad.

-- 
dwmw2

