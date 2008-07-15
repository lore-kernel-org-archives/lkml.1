Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbYGOSCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbYGOSCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbYGOSCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:02:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688AbYGOSCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:02:30 -0400
Date: Tue, 15 Jul 2008 11:01:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT pull] timer updates for 2.6.27
In-Reply-To: <alpine.LFD.1.10.0807151046180.3017@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807151100140.3017@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141827340.3283@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807151046180.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Linus Torvalds wrote:
> 
> Anyway, I'm not fixing it right now, since it's unclear which way to go, 
> but this need to be fixed _some_ way.

What the hell. The second type is always "unsigned long", and needs to be 
that since it's passed in as a pointer to "strict_strtoul()". So 
regardless of whether the cast to the first port should be removed or not, 
the second thing should be 0x%04lx.

		Linus
