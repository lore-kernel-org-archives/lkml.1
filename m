Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbXEaFz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbXEaFz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 01:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbXEaFzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 01:55:18 -0400
Received: from posti5.jyu.fi ([130.234.4.34]:46026 "EHLO posti5.jyu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXEaFzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 01:55:17 -0400
Date: Thu, 31 May 2007 08:54:28 +0300 (EEST)
From: Tero Roponen <teanropo@jyu.fi>
X-X-Sender: teanropo@jalava.cc.jyu.fi
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [3/4] 2.6.22-rc3: known regressions
In-Reply-To: <1180587109.4570.25.camel@daplas>
Message-ID: <Pine.LNX.4.64.0705310852400.8734@jalava.cc.jyu.fi>
References: <465C188F.9000900@googlemail.com>  <465C222A.8060003@googlemail.com>
  <alpine.LFD.0.98.0705301922560.26602@woody.linux-foundation.org>
 <1180587109.4570.25.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Antonino A. Daplas wrote:

> On Wed, 2007-05-30 at 19:33 -0700, Linus Torvalds wrote:
> > 
> > On Tue, 29 May 2007, Michal Piotrowski wrote:
> > > 
> 
> > > TTY
> > > 
> > > Subject    : tty-related oops in latest kernel(s)
> > > References : http://lkml.org/lkml/2007/5/27/104
> > > Submitter  : Tero Roponen <teanropo@jyu.fi>
> > > Status     : problem is being debugged
> > 
> > People seem to have debugged this to neofb palette handling, but I haven't 
> > seen a patch. Antonino?
> > 
> 
> Already posted one for testing. I'm waiting for Tero to confirm.
> 
> Tony
> 

Ok, I tested all the cases I have reported: no corruption
and nothing in slabinfo -v. This seems to be the right fix.

Thanks.

Acked-by: Tero Roponen <teanropo@jyu.fi>
