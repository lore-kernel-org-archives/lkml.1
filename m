Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYJORot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYJORot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYJORol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:44:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbYJORol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:44:41 -0400
Date: Wed, 15 Oct 2008 10:43:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Jiri Kosina <jkosina@suse.cz>, zippel@linux-m68k.org, sam@ravnborg.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [2.6 patch] HID: fix default building of all quirky devices
In-Reply-To: <20081015173245.GA19255@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.2.00.0810151036400.3288@nehalem.linux-foundation.org>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi> <20081015073011.GE20183@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz> <alpine.LFD.2.00.0810151002120.3288@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0810151009350.3288@nehalem.linux-foundation.org> <20081015173245.GA19255@cs181140183.pp.htv.fi>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Adrian Bunk wrote:
> 
> For me the more obvious way was what I did, but I agree that your 
> solution looks better.

I guess the "more obvious" part simply depends on what you're used to. The 
"default y" + "depends on XYZ" thing is a rather common model, so I find 
it to not just be shorter, but also "more obvious", exactly because I've 
seen it before.

Of course, the behaviour of 'default y' is much simpler (and _much_ more 
common!) for a bool than for a tristate, and the rules for tristate logic 
in general are obviously often a bit non-intuitive considering that we're 
almost always used to the binary kind, and then the fact that Kconfgi uses 
ternary logic has caused no end of hiccups.

		Linus
