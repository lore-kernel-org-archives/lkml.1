Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbXCRXLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbXCRXLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 19:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbXCRXLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 19:11:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58668 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXCRXLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 19:11:48 -0400
Date: Sun, 18 Mar 2007 16:10:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Christoph Lameter <clameter@sgi.com>, Steven Rostedt <rostedt@goodmis.org>,
       Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070316114415.GA26403@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0703181608320.6730@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
 <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
 <20070316114415.GA26403@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Mar 2007, Andi Kleen wrote:

> > In the future it is likely that x86_64 will significantly deviate from 
> 
> It already is in some cases. And I agree more will happen.

This is a *totally* bogus and idiotic argument.

x86-64 will get new capabilities, BUT IT WILL CONTINUE TO SUPPORT OLD 
x86-64 machines.

And those machines are basically identical to perfectly regular i386 
platforms.

So the whole argument that it would "diverge" is total crap. It obviously 
won't diverge, simply because the support for old setups is needed on 
x86-64 *regardless* of whether 32-bit support exists on the same platform 
or not.

There's a huge difference between divergence and "more capabilities".

		Linus
