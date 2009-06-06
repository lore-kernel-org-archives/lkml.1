Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZFFJd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZFFJd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZFFJdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:33:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:43457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZFFJdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:33:22 -0400
Subject: Re: [PATCH 1/6] headers_check fix: arm, hwcap.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090606091215.GB30463@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244118476.5172.29.camel@ht.satnam>
	 <20090604125306.GC24491@flint.arm.linux.org.uk>
	 <20090604201649.GC13892@uranus.ravnborg.org>
	 <20090605204805.GA22367@flint.arm.linux.org.uk>
	 <1244278211.2475.13.camel@ht.satnam>
	 <20090606091215.GB30463@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 15:04:12 +0530
Message-Id: <1244280852.2475.46.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-06 at 10:12 +0100, Russell King wrote:
> On Sat, Jun 06, 2009 at 02:20:11PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > The problem is why you are trying to complex things which are simple and
> > straight.
> 
> What you're saying is "you may not follow valid C ways of expressing
> conditional compilation" to which I say "go and piss in someone elses
> pool".
> 

Hmm, again you are trying to complex things.

Issue is not of valid C or not.

Issue is #if defined(__KERNEL__) && (<unknown>) is WRONG.

It should be :

#ifdef __KERNEL__
#ifdef <unknown>

otherwise how you will pass it to userspace.

Why you are looking on kernel side only why do not you think about user
space ?
please check how it will look at usr/include/asm-arm/hwcap.h

> Since the fix for this in unifdef is soo trivial, and it doesn't require
> people to write stuff in ways that stupid idiotic tools can understand,
> I'm NEVER going to apply the fix to hwdef.h.
> 
> So you now have two options: either supply the (correct) additional
> parameter to unifdef, or ignore the stupid idiotic warning message.
> 

I will go with 3rd option.

Thanks,
--
JSR

