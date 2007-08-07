Return-Path: <linux-kernel-owner+w=401wt.eu-S934209AbXHGM7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbXHGM7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbXHGM7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:59:46 -0400
Received: from mx.treblig.org ([80.68.94.177]:4262 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbXHGM7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:59:45 -0400
Date: Tue, 7 Aug 2007 13:59:39 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.22.1 Oops in put_nfs_open_context
Message-ID: <20070807125938.GB30370@gallifrey>
References: <20070806100813.GA30370@gallifrey> <20070806110107.0d0a2c2b.akpm@linux-foundation.org> <1186424394.6616.44.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186424394.6616.44.camel@localhost>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 13:57:31 up 95 days,  6:40,  1 user,  load average: 0.77, 0.67, 0.65
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Trond Myklebust (trond.myklebust@fys.uio.no) wrote:
> On Mon, 2007-08-06 at 11:01 -0700, Andrew Morton wrote:
> > On Mon, 6 Aug 2007 11:08:13 +0100 "Dr. David Alan Gilbert" <linux@treblig.org> wrote:
> > 
> > >   The oops below is from one of a pair of machines that run compiles;
> > > they're not managing to stay up for more than a day or two at a time
> > > this is the first time I've actually managed to capture an oops from one.
> > > They lock to the point where they still ping, and they won't toggle
> > > capslock.  A top left running on them showed it sitting with pdflush
> > > using 99% CPU.

<snip>

> > 
> > We did a list operation on an already-deleted list_head.
> > 
> > That code has changed a lot between 2..22 and 2.6.23-rc2.  Hopefully for the
> > better, although I can't immediately find a commit in there which looks like
> > it addresses this bug.
> 
> I believe this fix should address it.

OK, I've got 2.6.23-rc2 with that patch up and running on one of the
boxes; we'll see how long it survives.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
