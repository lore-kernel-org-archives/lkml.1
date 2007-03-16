Return-Path: <linux-kernel-owner+w=401wt.eu-S933637AbXCPLoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbXCPLoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933662AbXCPLoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:44:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49464 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933637AbXCPLoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:44:19 -0400
Date: Fri, 16 Mar 2007 12:44:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070316114415.GA26403@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org> <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain> <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In the future it is likely that x86_64 will significantly deviate from 

It already is in some cases. And I agree more will happen.

> i386. i386 is going to be gradually abandoned because it does not support 
> the ever larger memory sizes and be mainly used for embedded devices. 

The desktop/server user base is quite conservative so that will take a long 
time, but gradually probably.

> x86_64 is going to acquire more functionality that will not be available 
> for i386. We plan f.e. to add virtual memmap support for x86_64. Virtual 

What advantage would that have over the current setup?
We already should handle holes between nodes reasonably efficiently
and with nonlinear memory even holes inside nodes shouldn't be a problem.

> memmap support may require a large chunk of virtual memory space that is 
> not available on i386. Its not good to have to deal with i386 issues when 
> doing x86_64 arch development.

If the great merged architecture ever happens this would be needed anyways.
Just basic 32bit support isn't too difficult anyways -- the problem 
are more the old bugs.

-Andi
