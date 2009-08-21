Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZHUTWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZHUTWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZHUTWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:22:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbZHUTWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:22:11 -0400
Date: Fri, 21 Aug 2009 12:19:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       catalin.marinas@arm.com, a.p.zijlstra@chello.nl, jens.axboe@oracle.com,
       fweisbec@gmail.com, stable@kernel.org, srostedt@redhat.com,
       tglx@linutronix.de
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in
 do_one_initcall()
In-Reply-To: <alpine.LFD.2.01.0908211207410.3158@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908211217411.3158@localhost.localdomain>
References: <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org> <20090821111450.GA32037@elte.hu> <20090821104820.60948082.akpm@linux-foundation.org> <alpine.LFD.2.01.0908211108000.3158@localhost.localdomain> <20090821190226.GA28519@elte.hu>
 <alpine.LFD.2.01.0908211207410.3158@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Aug 2009, Linus Torvalds wrote:
> 
> And we probably should really complain more actively about big stack 
> frames. We have that CONFIG_FRAME_WARN thing, but it's set very high. 

Hmm. Setting it down to 256 on x86-64 does cause a fair number of 
warnings even for something like my personal build (that avoids all the 
crazy drivers etc), but it looks "manageable" - ie something where a 
kernel developer should try it, and fix all the ones that they maintain.

And if you don't get any warnings in your area, try lowering it to 100 or 
something.

		Linus
