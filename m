Return-Path: <linux-kernel-owner+w=401wt.eu-S1751160AbXKIFLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbXKIFLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 00:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXKIFLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 00:11:36 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53103 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbXKIFLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 00:11:36 -0500
Date: Fri, 9 Nov 2007 00:09:19 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: Re: [PATCH] Add the macro to test if "exactly_one_bit_set" to log2.h.
In-Reply-To: <20071108203640.340751ba.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711090006430.5113@localhost.localdomain>
References: <Pine.LNX.4.64.0711061135310.23545@localhost.localdomain>
 <20071108203640.340751ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Andrew Morton wrote:

> > On Tue, 6 Nov 2007 11:38:52 -0500 (EST) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> >
> > While this macro is defined in terms of "is_power_of_2" and is
> > therefore functionally equivalent, the visual semantics are
> > sometimes more appropriate for what is actually being tested.
>
> This is gettig a bit anal, but I guess you're the is_power_of_2
> maintainer.
>
> > ---
> >
> > diff --git a/include/linux/log2.h b/include/linux/log2.h
> > index c8cf5e8..d0d324e 100644
> > --- a/include/linux/log2.h
> > +++ b/include/linux/log2.h
> > @@ -55,6 +55,12 @@ bool is_power_of_2(unsigned long n)
> >  }
> >
> >  /*
> > + *  And for folks who want slightly different semantics ...
> > + */
> > +
> > +#define exactly_one_bit_set is_power_of_2

actually, i could go either way on this one.  it wasn't originally my
idea, but i tossed it out there because i have, in fact, seen comments
that explicitly said something along the lines of "make sure that
exactly one bit is set".  so i'll leave it up to someone else to
decide whether it should go in.  it's not something i'm going to go to
the mats over one way or the other.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
