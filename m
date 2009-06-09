Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZFISIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZFISIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZFISIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:08:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbZFISIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:08:46 -0400
Date: Tue, 9 Jun 2009 11:07:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <alpine.LFD.2.01.0906091103080.6847@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906091106470.6847@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
 <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu> <4A2E7B40.4070608@zytor.com> <alpine.LFD.2.01.0906091103080.6847@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Jun 2009, Linus Torvalds wrote:
>
> And they'd be even less common if the whole "64-bit kernel even if you do 
> a 32-bit distro" was more common.

Side note: intel is to blame too. I think several Atom versions were 
shipped with 64-bit mode disabled. So even "modern" CPU's are sometimes 
artifically crippled to just 32-bit mode.

			Linus
