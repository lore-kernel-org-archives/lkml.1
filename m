Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891Ab0ATKne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0ATKne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681Ab0ATKnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:43:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:40084 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab0ATKna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ehBUBgOqBeh98k0AZnuHnofw5ql2CLmnPT2/l6XtgWbrrq0pkuEaQW5zYb4X87KRMu
         cBwWb3jP+XCOE0omCOTUl/wntpKr9M1rmzQYCkvpOcqazgqVx7bfk9VTtWiJyf81S9UL
         DUI9rieWtngSI3PGfR6xhItbqe1rPbTfcdSeY=
Date: Wed, 20 Jan 2010 11:43:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100120104322.GA5149@nowhere>
References: <20100119211646.GF16096@redhat.com> <20100120111220.e7fb4e2c.sfr@canb.auug.org.au> <20100120054950.GB27108@elte.hu> <20100120061551.GB6588@in.ibm.com> <20100120062834.GB12165@elte.hu> <20100120064026.GC6588@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120064026.GC6588@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 12:10:26PM +0530, Ananth N Mavinakayanahalli wrote:
> > It will cause conflicts with various other trees and increases the overhead 
> > all around. It also causes us to trust linux-next bugreports less - as it's 
> > not the 'next Linux' anymore. Also, there's virtually no high-level technical 
> > review done in linux-next: the trees are implicitly trusted (because they are 
> > pushed by maintainers), bugs and conflicts are reported but otherwise it's a 
> > neutral tree that includes pretty much any commit indiscriminately.
> > 
> > If you need review and testing there's a number of trees you can get inclusion 
> > into.
> 
> So would -tip be one of them? If so could you pull the utrace-ptrace
> branch in?
> 
> Or did you intend some other tree (random-tracing)? (Though I think a
> ptrace reimplementation isn't 'random'-tracing :-))


Heh. No this is a tree I use for, well, random tracing patches indeed,
which has extended to random tracing/perf/* patches by the time.
I sometimes relay other's patches to Ingo toward this tree but this is
usually about small volumes and for small term storage: patches that
have been reviewed/acked already.

utrace/uprobe is about high volume and longer time debate/review/maintainance
and I won't have the time to carry this.


 
> Ananth

