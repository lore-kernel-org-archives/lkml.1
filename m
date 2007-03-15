Return-Path: <linux-kernel-owner+w=401wt.eu-S1422919AbXCOQAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422919AbXCOQAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422917AbXCOQAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:00:44 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57807 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422919AbXCOQAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:00:43 -0400
Date: Thu, 15 Mar 2007 08:59:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin Bligh <mbligh@mbligh.org>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <45F96B57.10206@mbligh.org>
Message-ID: <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <45F96B57.10206@mbligh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Mar 2007, Martin Bligh wrote:
> 
> Can't we move the shared files into a new shared arch/ subdirectory
> (ia32_64 or whatever), and have them included from both places?

That's *exactly* what the patches do (except it's called "arch/x86", which 
is clearly the best option - please don't use "ia" _anywhere_ except for 
"ia64", since that's the only architecture that is really "intel 
architecture").

> On the downside, it's more ../../.. type stuff. On the upside,
> they're more cleanly separated and it's apparent what's going on.
> Seems nicer to me than drivers/ and kernel/ for stuff that's
> really arch specific, but shared between two arches.

Absolutely. I'm agreeing violently. I just suspect not a lot of people 
really looked at the patches..

		Linus
