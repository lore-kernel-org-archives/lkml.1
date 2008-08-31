Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbYHaTj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbYHaTj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbYHaTjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:39:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbYHaTjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:39:45 -0400
Date: Sun, 31 Aug 2008 12:39:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: David Sanders <linux@sandersweb.net>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <20080831122751.72afafb5@infradead.org>
Message-ID: <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net> <alpine.LFD.1.10.0808311140060.12958@nehalem.linux-foundation.org> <20080831122751.72afafb5@infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 31 Aug 2008, Arjan van de Ven wrote:
>
> it's probably even a security bug in that I don't see what would be
> stopping a ring 3 user process from executing these instructions...

Well, it could be that Virtual PC raises a #UD exception in the virtual 
machine. In user space, that would just cause the kernel to kill the poor 
innocent victim. But when the kernel gets a #UD exception on what it 
expects to be a nop, it just won't work.

		Linus
