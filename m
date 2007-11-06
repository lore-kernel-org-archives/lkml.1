Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXKFSzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXKFSzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXKFSzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:55:40 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:43096 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbXKFSzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:55:39 -0500
Date: Tue, 6 Nov 2007 13:53:29 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, matthew@wil.cx
Subject: Re: [PATCH] Add the macro to test if "exactly_one_bit_set" to log2.h.
In-Reply-To: <4730AE66.6030501@panasas.com>
Message-ID: <Pine.LNX.4.64.0711061352520.29701@localhost.localdomain>
References: <Pine.LNX.4.64.0711061135310.23545@localhost.localdomain>
 <4730AE66.6030501@panasas.com>
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

On Tue, 6 Nov 2007, Boaz Harrosh wrote:

> On Tue, Nov 06 2007 at 18:38 +0200, "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> > While this macro is defined in terms of "is_power_of_2" and is
> > therefore functionally equivalent, the visual semantics are sometimes
> > more appropriate for what is actually being tested.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
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
>
> at_most_one_bit_set No?

no, it really is *exactly* one bit set.  zero is not considered a
power of two.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
