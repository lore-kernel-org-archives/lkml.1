Return-Path: <linux-kernel-owner+w=401wt.eu-S1761316AbYCUVZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316AbYCUVZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbYCUVZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:25:24 -0400
Received: from www.tglx.de ([62.245.132.106]:38682 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343AbYCUVZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:25:24 -0400
Date: Fri, 21 Mar 2008 22:24:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: [patch 2/5] infrastructure to debug (dynamic) objects
In-Reply-To: <20080321135513.8f1c2a69.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.00.0803212215410.3781@apollo.tec.linutronix.de>
References: <20080321200300.310393657@linutronix.de> <20080321200321.650649403@linutronix.de> <20080321135513.8f1c2a69.randy.dunlap@oracle.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Randy Dunlap wrote:
> > +	  If you say Y here, additional code will be inserted into the
> > +	  kernel to track the life time of various objects and validate
> 
>                               lifetime

Fixed.
 
> > +	help
> > +	  This enables checks whether a k/v free operation frees an area
> 
> Please say "kfree/vfree" so that we (I, others) don't have to think
> "what the heck is a k/v free operation?".

Ooops. Missed that one. Fixed it in the docs already.
 
> > +/*
> > + * We run out of memory. That means we probably have tons of objects
> 
>          ran

Sigh. This is one of the words which hunt me since school.

> > +/**
> > + * debug_object_init_on_stack - debug checks when an object on stack is
> > + *				initialized
> 
> Unfortunately the first line of kernel-doc notation ("short description")
> is limited to one line.  Even if it exceeds 80 columns.  :(

Fixed
 
Thanks,

	tglx
