Return-Path: <linux-kernel-owner+w=401wt.eu-S1161258AbXCNNFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161258AbXCNNFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161259AbXCNNFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:05:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48778 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161258AbXCNNFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:05:33 -0400
Date: Wed, 14 Mar 2007 14:05:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314130531.GA27498@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <1173875708.31159.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173875708.31159.17.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The thing is others and I (and you) are working on getting paravirt_ops
> working for x86_64.  There's a lot of overlap between i386 and x86_64.
> Right now the i386 is ahead of x86_64 and the code seems to be put more
> in the arch/i386 arch.  So now we are going to introduce a
> new ../../i386 hack to get to a shared paravirt_shared.c(?).  Or do we

What would you like exactly to share?  

> just continue on keeping the x86_64 as a separate entity, with a lot of
> duplicate code?

When it makes sense to share the code it can be shared. That is already
done today. But the existing Makefile mechanisms work fine for that.

Making sense: 
- There is actually a lot of shared code
- The supported hardware is the same (remember x86-64 is only for 
modern x86 hardware, while i386 has a much longer legacy) 
- No ifdefs


-Andi
