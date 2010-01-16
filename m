Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069Ab0APUfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0APUfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 15:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403Ab0APUfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 15:35:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094Ab0APUfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 15:35:07 -0500
Date: Sat, 16 Jan 2010 12:34:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
In-Reply-To: <20100116170338.GA17175@elte.hu>
Message-ID: <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>
References: <20100116170338.GA17175@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Jan 2010, Ingo Molnar wrote:
> 
> Cyrill Gorcunov (1):
>       x86: kernel_thread() -- initialize SS to a known state

This looks bogus. Why does it do it only on x86-64?

Either people care about SS or they don't (the answer, I suspect, is "they 
don't"). But if they care, we should do it on both 32-bit _and_ 64-bit, 
no?

		Linus
