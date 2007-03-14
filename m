Return-Path: <linux-kernel-owner+w=401wt.eu-S1751443AbXCNQxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbXCNQxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXCNQxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:53:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbXCNQxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:53:05 -0400
Date: Wed, 14 Mar 2007 09:52:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <Pine.LNX.4.61.0703140841580.20730@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0703140950090.9690@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org>
 <Pine.LNX.4.61.0703140841580.20730@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2007, Jan Engelhardt wrote:
> >
> >Seems appropriate, but I really don't care what it's called.  One thing about
> >this name, is that typing arch/x86<Tab> doesn't tab complete x86_64 anymore.
> >But if you can think of something better, I'd be happy to apply it.
> 
> 80x86
> 8086
> ia32   <- I'd go with this for lack of more entries on this list.

But the whole point is that this is *not* a 32-bit file.

It's a file *shared* between 32-bit and 64-bit kernels.

Which is why plain "x86" is the right name. Yeah, Intel calls it "IA" 
these days, but that's just crazy speak (and probably a combination of a 
reaction against "amd64" and a way to hide the embarrassment that is 
"ia64" by confusing the naming so much that one day people won't remember 
that there was _another_ IA that was a total failure).

		Linus

