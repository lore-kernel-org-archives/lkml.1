Return-Path: <linux-kernel-owner+w=401wt.eu-S1764420AbYBWVDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764420AbYBWVDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 16:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbYBWVCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 16:02:53 -0500
Received: from www.tglx.de ([62.245.132.106]:47123 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761127AbYBWVCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 16:02:52 -0500
Date: Sat, 23 Feb 2008 22:01:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       zippel@linux-m68k.org, schwab@suse.de, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values
 to do_div() [try #3]
In-Reply-To: <20080223000455.a0f543e1.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802232200300.7583@apollo.tec.linutronix.de>
References: <20080221165035.16571.67531.stgit@warthog.procyon.org.uk> <20080223000455.a0f543e1.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008, Andrew Morton wrote:

> On Thu, 21 Feb 2008 16:50:35 +0000 David Howells <dhowells@redhat.com> wrote:
> 
> > From: David Howells <dhowells@redhat.com>
> > 
> > The kernel NTP code shouldn't hand 64-bit *signed* values to do_div().  Make it
> > instead hand 64-bit unsigned values.  This gets rid of a couple of warnings.
> 
> On certain architectures.  It would have bene nice to mention what those
> architectures are, and to quote the warnings.  Next time, please ;)
> 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > ---
> > 
> >  kernel/time/ntp.c |   12 +++++++-----
> 
> Thomas, do you consider ntp to fall under git-hrt?

I'll pick it up.

Thanks,

	tglx

