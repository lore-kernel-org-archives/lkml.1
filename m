Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbZE3NWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbZE3NWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZE3NW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:22:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756AbZE3NW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:22:26 -0400
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
From: Peter Zijlstra <peterz@infradead.org>
To: pageexec@freemail.hu
Cc: "Larry H." <research@subreption.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <4A211BA8.8585.17B52182@pageexec.freemail.hu>
References: <20090522073436.GA3612@elte.hu>
	 , <20090530054856.GG29711@oblivion.subreption.com>
	 , <1243679973.6645.131.camel@laptop>
	 <4A211BA8.8585.17B52182@pageexec.freemail.hu>
Content-Type: text/plain
Date: Sat, 30 May 2009 15:21:47 +0200
Message-Id: <1243689707.6645.134.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-30 at 13:42 +0200, pageexec@freemail.hu wrote:
> > Why waste time on this?
> 
> e.g., when userland executes a syscall, it 'can run kernel code'. if that kernel
> code (note: already exists, isn't provided by the attacker) gives unintended
> kernel memory back to userland, there is a problem. that problem is addressed
> in part by early sanitizing of freed data.

Right, so the whole point is to minimize the impact of actual bugs,
right? So why not focus on fixing those actual bugs? Can we create tools
to help us find such bugs faster? We use sparse for a lot of static
checking, we create things like lockdep and kmemcheck to dynamically
find trouble.

Can we instead of working around a problem, fix the actual problem?

