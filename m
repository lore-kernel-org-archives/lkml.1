Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbZEVUsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbZEVUsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZEVUr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:47:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807AbZEVUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:47:57 -0400
Date: Fri, 22 May 2009 13:47:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Takashi Iwai <tiwai@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sound fixes
In-Reply-To: <s5hzld5m47q.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.2.01.0905221341090.3555@localhost.localdomain>
References: <s5hzld5m47q.wl%tiwai@suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 May 2009, Takashi Iwai wrote:
> 
> please pull ALSA updates for v2.6.30-rc6 from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus
> 
> containing just the following trivial fixes.

Thanks, pulled.

I also note that you've been active on

	http://bugzilla.kernel.org/show_bug.cgi?id=13250

but quite frankly, my opinion is that the workaround listed there isn't a 
fix at all. Why isn't such a frontpanel configuration choice exported as a 
switch, so that you can access it with alsamixer, rather than playing 
crazy games with some magic sysfs files?

If it cannot be autodetected, it should still be visible as a mixer 
option, not some magic. No?

			Linus
