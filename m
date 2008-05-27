Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYE0PLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYE0PLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbYE0PLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:11:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:60125 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756419AbYE0PLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:11:40 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX194pzgkEex4y9xKXX58JhC9hUuFZLDGtwbBECY4j6
	9qQ89UrN7u40gc
Date: Tue, 27 May 2008 17:11:36 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       James Morris <jmorris@namei.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Message-ID: <20080527151136.GA20750@alice>
References: <20080526143422.GA3203@alice> <84144f020805270800l5911ed02ia7a92d96a8aa32a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84144f020805270800l5911ed02ia7a92d96a8aa32a7@mail.gmail.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26-rc3 (x86_64)
X-Uptime: 17:07:05 up  4:24,  1 user,  load average: 0.28, 1.62, 1.62
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> (added some cc's)
> 
> On Mon, May 26, 2008 at 5:34 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
> > i enabled CONFIG_SECURITY on current git and get tons of
> > Redzone overwritten errors during early boot, even
> > with CONFIG_SECURITY_CAPABILITIES and CONFIG_SECURITY_NETWORK
> > disabled. After a while it ends with a kernel panic
> > saying: not syncing: Out of memory and no killable process...
> > Root partition is ext3 format.
> 
> So what kernel version is this and what's the last known version that
> worked? As it's early boot crash, maybe you can try to do git bisect
> on it?


this is 2.6.26-rc4, i didnt test any earlier versions so far
(ok, i did test some pre -rc4 git versions i think 4 days
ago, but they also showed the problem) this is the
first time that i enabled CONFIG_SECURITY on my testbox.

I am currently trying to reproduce this with SLAB as Vegard
suggested for the kmemcheck report. After this I'll retest this
on a fresh tree to make sure it isnt something buggy on my part
and try some older kernels.

Greetings, Eric
