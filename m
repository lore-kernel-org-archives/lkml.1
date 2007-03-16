Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbXCPE2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbXCPE2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 00:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbXCPE2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 00:28:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48666 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753406AbXCPE23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 00:28:29 -0400
Date: Thu, 15 Mar 2007 21:28:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <1173977264.7922.24.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
References: <20070314050819.536207642@goodmis.org>  <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu>  <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
  <45F96B57.10206@mbligh.org>  <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
  <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Steven Rostedt wrote:

> On Thu, 2007-03-15 at 17:06 +0100, Andi Kleen wrote:
> 
> > Well I just see a lot of pain from these patches but I doubt 
> > they will avoid any bugs. If people don't compile test both
> > archs they will always likely break on another. There are lots
> > of subtle dependencies that are not expressed in the pathname
> > even after this intrusive operation (e.g. in the includes).
> > 
> > That's just how it is.
> 
> Or that's just how you see it.

In the future it is likely that x86_64 will significantly deviate from 
i386. i386 is going to be gradually abandoned because it does not support 
the ever larger memory sizes and be mainly used for embedded devices. 
x86_64 is going to acquire more functionality that will not be available 
for i386. We plan f.e. to add virtual memmap support for x86_64. Virtual 
memmap support may require a large chunk of virtual memory space that is 
not available on i386. Its not good to have to deal with i386 issues when 
doing x86_64 arch development.

