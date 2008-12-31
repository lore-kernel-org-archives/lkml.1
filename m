Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYLaVXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYLaVXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 16:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYLaVXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 16:23:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbYLaVXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 16:23:41 -0500
Date: Wed, 31 Dec 2008 13:22:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Helge Deller <deller@gmx.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel
 modules (take 4)
In-Reply-To: <20081231105425.9ccac21d.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain>
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au> <495B5806.3080505@gmx.de> <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain> <ada63l0qmba.fsf@cisco.com> <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain>
 <20081231105425.9ccac21d.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Dec 2008, Andrew Morton wrote:
> 
> Adrian claimed that it was gcc-4.1.0 and 4.1.1 only.  He proposed
> banning them: http://lkml.org/lkml/2008/8/5/444

If it really is just those releases, then yes, considering the number of 
cases we apparently have, and considering how ugly it is in some cases to 
move the weak function anywhere else, maybe banning those versions is the 
proper thing to do.

It probably won't hurt very many people - yeah, some people will be forced 
to upgrade, but I have this memory of early 4.1 having had other bugs 
anyway, so it's probably a good idea.

		Linus
