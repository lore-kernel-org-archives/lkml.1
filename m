Return-Path: <linux-kernel-owner+w=401wt.eu-S933180AbXGUHti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbXGUHti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 03:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758662AbXGUHt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 03:49:27 -0400
Received: from ns.suse.de ([195.135.220.2]:41152 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260AbXGUHt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 03:49:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Date: Sat, 21 Jul 2007 09:42:48 +0200
User-Agent: KMail/1.9.6
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
References: <1184970779.4012.38.camel@chaos> <200707210806.12880.ak@suse.de> <20070721073533.GE3801@stusta.de>
In-Reply-To: <20070721073533.GE3801@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210942.48444.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007 09:35:33 Adrian Bunk wrote:

> The problem with the current "merging" is that it's extremely hard to 
> figure out whether some code in x86_64 might be using some code in i386 
> since there are currently 5 (five) different mechanisms used for sharing 
> code between the two architectures.
> 
> It happens so often that someone accidentally breaks one architecture 
> because he didn't notice the code also gets used on the other 
> architecture.

That's not changing at all. Especially with even more sharing, (than I think
would be prudent) like Thomas treated, you'll likely have to test compile both
for most changes.

-Andi
