Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367Ab0ATGkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0ATGkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954Ab0ATGkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:40:36 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50105 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0ATGkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:40:35 -0500
Date: Wed, 20 Jan 2010 12:10:26 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100120064026.GC6588@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100119211646.GF16096@redhat.com> <20100120111220.e7fb4e2c.sfr@canb.auug.org.au> <20100120054950.GB27108@elte.hu> <20100120061551.GB6588@in.ibm.com> <20100120062834.GB12165@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120062834.GB12165@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 07:28:34AM +0100, Ingo Molnar wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > On Wed, Jan 20, 2010 at 06:49:50AM +0100, Ingo Molnar wrote:

...
 
> > On the other hand, having ptrace/utrace in the -next tree will give it a
> > lot more testing, while any outstanding technical issues are being addressed.
> 
> Including experimental code that is RFC and which is not certain to go 
> upstream is certainly not the purpose of linux-next though.

OK.

> It will cause conflicts with various other trees and increases the overhead 
> all around. It also causes us to trust linux-next bugreports less - as it's 
> not the 'next Linux' anymore. Also, there's virtually no high-level technical 
> review done in linux-next: the trees are implicitly trusted (because they are 
> pushed by maintainers), bugs and conflicts are reported but otherwise it's a 
> neutral tree that includes pretty much any commit indiscriminately.
> 
> If you need review and testing there's a number of trees you can get inclusion 
> into.

So would -tip be one of them? If so could you pull the utrace-ptrace
branch in?

Or did you intend some other tree (random-tracing)? (Though I think a
ptrace reimplementation isn't 'random'-tracing :-))

Ananth
