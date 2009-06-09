Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbZFIR7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbZFIR7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZFIR7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:59:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53692 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZFIR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:59:47 -0400
Message-ID: <4A2E7B40.4070608@zytor.com>
Date: Tue, 09 Jun 2009 08:09:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu>
In-Reply-To: <20090609111719.GA4463@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> OTOH, highmem is clearly a useful hardware enablement feature with a 
> slowly receding upside and a constant downside. The outcome is 
> clear: when a critical threshold is reached distros will stop 
> enabling it. (or more likely, there will be pure 64-bit x86 distros)
> 

A major problem is that distros don't seem to be willing to push 64-bit
kernels for 32-bit distros.  There are a number of good (and
not-so-good) reasons why users may want to run a 32-bit userspace, but
not running a 64-bit kernel on capable hardware is just problematic.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

