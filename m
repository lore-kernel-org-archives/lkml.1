Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbYEPWs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbYEPWs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYEPWsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:48:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756223AbYEPWsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:48:18 -0400
Date: Fri, 16 May 2008 15:47:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 May 2008, Thomas Gleixner wrote:
> 
> please pull the latest x86 fixes from:
> 
>    ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

No.

You have three real commits there.

And *six* unnecessary merges.

Why do you merge my tree? Is it the x86 tree, or is it the "general 
development tree"?

If it's the x86 tree, it shouldn't need to merge everythign else all the 
time. Certainly not if it means that moer than half the commits are just 
merges.

Do nice topic branches, where each branch has a reason for existing. The 
"x86-fixes-for-linus" branch has x86 fixes. 

This happens almost every time somebody starts using git properly: at that 
point the rebasing no longer hides bad habits.

		Linus
