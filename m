Return-Path: <linux-kernel-owner+w=401wt.eu-S1030877AbXCNUHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030877AbXCNUHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030880AbXCNUHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:07:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39503 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030877AbXCNUHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:07:08 -0400
Date: Wed, 14 Mar 2007 21:07:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314200704.GB376@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <20070314180933.GA12994@elte.hu> <Pine.LNX.4.64.0703141120530.9690@woody.linux-foundation.org> <20070314195916.GA5674@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314195916.GA5674@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the x86_64 and i386 trees have diverged quite a bit though, so this will 
> be a major logistical undertaking. And with Andi opposed to 
> fundamentally it it also lacks a bit of manpower i guess :-/

I'm not fundamentally opposed, just sceptical on the effort:gain ratio.

> Andrew's laptop only half a dozen times! ;) But .. in the long run, it's 
> alot easier to think about unified code. 32-bit x86 will certainly stay 
> with us for at least 10-20 years, and the best model for maintainance is 
> having one codebase.

Not sure -- i'm often glad I don't have to care about all the old 32bit
systems on x86-64. I have no problem with modern 32bit x86 systems,
but old x86 tends to be very different from new x86. And all the old erratas
are scary.

-Andi
