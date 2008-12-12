Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYLLP4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYLLP4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbYLLP4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:56:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:45952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbYLLP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:56:36 -0500
Date: Fri, 12 Dec 2008 07:57:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Eric Anholt <eric@anholt.net>,
       nix.or.die@googlemail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081212075746.4ddc9349@infradead.org>
In-Reply-To: <20081212082456.GA25106@elte.hu>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
	<49407CE1.9090600@googlemail.com>
	<1228979963.3254.8.camel@gaiman.anholt.net>
	<200812111707.20857.elendil@planet.nl>
	<alpine.LFD.2.00.0812110814360.3340@localhost.localdomain>
	<20081211163548.GA11859@elte.hu>
	<alpine.LFD.2.00.0812110902450.3340@localhost.localdomain>
	<20081211203604.GA14817@elte.hu>
	<84144f020812111246m7f6470f2n8b09283f54ead81@mail.gmail.com>
	<20081212082456.GA25106@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 09:24:56 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Hi Ingo,
> > 
> > On Thu, Dec 11, 2008 at 10:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > > ok. In this case i'd suggest we should just remove the warning.
> > > People do get scared by needless kernel stack dumps - no matter
> > > whether it's marked informational or not.
> > >
> > > So how about the patch below, queued up in tip/x86/debug? Arjan,
> > > what do you think?
> > 
> > How come we don't put it under CONFIG_X86_DEBUG or something and
> > hide somewhere in the "Kernel debugging" menu?
> 
> okay - how about the following then instead - we still keep the
> warning, but do various things to make it appear less scary.

another thing we could do is try to only warn if you cross bar
boundaries but not if you cross other user-of-the-resource boundaries.
