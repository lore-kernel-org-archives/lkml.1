Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbXCPThF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbXCPThF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXCPThE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:37:04 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:34448 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbXCPThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:37:03 -0400
Subject: Re: [patch 05/26] Xen-paravirt_ops: paravirt_ops: hooks to set up
	initial pagetable
From: Steven Rostedt <srostedt@stny.rr.com>
Reply-To: rostedt@goodmis.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@muc.de>, xen-devel@lists.xensource.com,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <45FAE46F.7080009@goop.org>
References: <20070301232443.195603797@goop.org>
	 <20070301232526.611972133@goop.org> <20070316093348.GS23174@elte.hu>
	 <45FAE46F.7080009@goop.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 16 Mar 2007 15:35:44 -0400
Message-Id: <1174073744.11050.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 11:39 -0700, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> >> +	/* Make sure kernel address space is empty so that a pagetable
> >> +	   will be allocated for it. */
> >>     
> >
> > comment style.
> >   
> 
> As you've noticed its a comment style I use quite often.  I use it for
> what's essentially a little local comment, rather than a block comment
> which really needs to draw attention to itself.  In this case, I think using
> 

Understood, but then you need to make that comment a single line :)

The way Linux code prefers comments (like the code itself actually
prefers it!) is single line comments stay on a single line, and
multiline comments are always block.

So it's either:

   /* my little comment here */

or 

   /*
    * This comment, although small and to the point, does span multiple
    * lines and regardless, needs to be a block comment.
    */

I guess it just makes it easier on the eyes when everything conforms and
others need to look at / maintain your code.


-- Steve


