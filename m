Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYJ3UFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYJ3UFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYJ3UFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:05:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYJ3UFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:05:25 -0400
Date: Thu, 30 Oct 2008 16:05:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH][RFC] x86: add non x86 build configuration
In-Reply-To: <20081030195107.GK27407@elte.hu>
Message-ID: <alpine.DEB.1.10.0810301602380.19996@gandalf.stny.rr.com>
References: <200810281802.m9SI2fYX030138@hera.kernel.org> <20081029091857.GA4414@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0810292139170.6145@gandalf.stny.rr.com> <20081030195107.GK27407@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> One important detail: could you please flip around the modality of the 
> option? Right now it's CONFIG_SIMULATE_NON_X86_CONFIGURATION, and that 
> will be set by allyesconfig. But it has the exact opposite effect of 
> an "all yes" config.

Hmm, I made it a choice, with the "Normal Config" as default, so that
allyesconfig will not set it. Does it get set for you when you do an 
allyesconfig?  I had to do the following:

  make allyesconfig
  make menuconfig <change to NON x86>

to get this option on for testing.

> 
> So please name it something like CONFIG_STANDARD_X86_FEATURES, and 
> also make it depend on CONFIG_EMBEDDED (only allow it to be turned off 
> when EMBEDDED is enabled).

I'll have to extend my Kbuild foo to learn to do these inverse selects.

-- Steve

