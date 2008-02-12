Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbYBLQKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbYBLQKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbYBLQKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:10:06 -0500
Received: from waste.org ([66.93.16.53]:35224 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbYBLQKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:10:04 -0500
Subject: Re: [PATCH] Configure out doublefault exception handler (Linux
	Tiny)
From: Matt Mackall <mpm@selenic.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080212150013.57cb954e@crazy>
References: <20080212110825.35db27cb@crazy>
	 <20080212130428.GA32757@uranus.ravnborg.org>
	 <20080212150013.57cb954e@crazy>
Content-Type: text/plain; charset=utf-8
Date: Tue, 12 Feb 2008 10:02:12 -0600
Message-Id: <1202832132.12383.93.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 15:00 +0100, Thomas Petazzoni wrote:
> Hi Sam,
> 
> Le Tue, 12 Feb 2008 14:04:28 +0100,
> Sam Ravnborg <sam@ravnborg.org> a écrit :
> 
> > We already have this in arch/x86/Kconfig.debug:
> 
> Oops, my usual "find . -name Kconfig" missed it. Thanks for pointing it
> out!

The fact that you didn't have to add any makefile bits should have been
a hint.

> > It may need a small update if this is valid for both 32 and 64 bit.
> 
> Doesn't seem so: there's only a doublefault_32.c, no doublefault_64.c.
> However, I don't know the details of x86_64.

I bet there's some doublefault-handling code hiding somewhere. It's not
the sort of thing it'd make sense to take out of the architecture.

-- 
Mathematics is the supreme nostalgia of our time.

