Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZDXPOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZDXPOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZDXPOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:14:00 -0400
Received: from sous-sol.org ([216.99.217.87]:60912 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753457AbZDXPN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:13:59 -0400
Date: Fri, 24 Apr 2009 08:12:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wright <chrisw@sous-sol.org>, Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
Message-ID: <20090424151201.GX3036@sequoia.sous-sol.org>
References: <20090423082031.GA599@elte.hu> <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231019001.24293@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231101030.24293@gandalf.stny.rr.com> <49F09C35.1080006@goop.org> <20090423172138.GR3036@sequoia.sous-sol.org> <20090423180238.GS3036@sequoia.sous-sol.org> <alpine.DEB.2.00.0904231432170.24293@gandalf.stny.rr.com> <20090423184344.GT3036@sequoia.sous-sol.org> <20090424083648.GK24912@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424083648.GK24912@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> * Chris Wright <chrisw@sous-sol.org> wrote:
> > OK, saves a whopping 200 bytes on my .config too ;-)
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 8041385	1816009	1822720	11680114	 b23972	vmlinux.orig
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 8041181	1816009	1822720	11679910	 b238a6	vmlinux
> 
> This really demonstrates the cost of paravirt :-/
> 
> Please lets not forget this patch - it makes sense regardless of 
> whether it works around the bug i reported.

Yup, Steve picked it up and it's in his most recent ftrace pull request
to you.

thanks,
-chris
