Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYBJJPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYBJJPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYBJJPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:15:30 -0500
Received: from www.tglx.de ([62.245.132.106]:39121 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbYBJJP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:15:28 -0500
Date: Sun, 10 Feb 2008 10:14:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
In-Reply-To: <alpine.LFD.1.00.0802092344070.2896@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802101003340.12988@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0802092246390.3145@apollo.tec.linutronix.de> <20080209172538.87994c61.randy.dunlap@oracle.com> <alpine.LFD.1.00.0802092344070.2896@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008, Linus Torvalds wrote:
> On Sat, 9 Feb 2008, Randy Dunlap wrote:
> 
> So Thomas, don't do this. I don't like it. The same way I didn't like 
> seeing Ingo trying to mix in a kgdb pull into his x86 pull. Keep these 
> things separate - git is *really* good at having multiple branches with 
> different lines of development, use it that way (or send odd-ball misc 
> patches just as emails).

Please accept my apologies. 

I went through the content, pointed out the other two non x86 patches
and did not notice the vsprintf one. My bad.

> PS. And no, maybe I don't always notice. I bet maintainers can slip things 
> by me all the time without me waking up to it. The fact that it sometimes 
> works doesn't mean that it's a good idea, though - it just means that if I 
> catch it, my level of trust goes down. 

I know. And I have no intention to sneak stuff in that way.

Conclusions:
1) add diffstat to the pull request generator
2) add alert about non x86 stuff to it and send it separate
3) postpone pull requests to the morning hours, even if time is short

Thanks,

	tglx
