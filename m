Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXCNUVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXCNUVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXCNUVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:21:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48880 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226AbXCNUVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:21:32 -0400
Date: Wed, 14 Mar 2007 21:21:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314202131.GC376@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <20070314180933.GA12994@elte.hu> <Pine.LNX.4.64.0703141120530.9690@woody.linux-foundation.org> <20070314195916.GA5674@elte.hu> <20070314201156.GA9603@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314201156.GA9603@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> also, having the x32_ and x64_ prefix is a painful daily reminder for 
> all of us changing the architecture that 'this stuff needs to be 
> unified!'.

We would probably stuck with that forever and it just looks ugly.
Non paravirt xen uses such a setup and I always hated it.

Besides the architecture is called x86_64

I don't see a problem with step by step unifying what makes sense 
in the current setup.

-Andi

