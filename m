Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbZJMLrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbZJMLrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759562AbZJMLrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:47:48 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:59488 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759560AbZJMLrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:47:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19156.26810.772413.603275@pilspetsen.it.uu.se>
Date: Tue, 13 Oct 2009 13:47:06 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Using intptr_t and uintptr_t in Kernel
In-Reply-To: <f22d86810910130158u73c2f669wa129fa4e8d48b521@mail.gmail.com>
References: <f22d86810910130037x48cac5c1s8928a6ff49dda381@mail.gmail.com>
	<19156.16146.326389.380625@pilspetsen.it.uu.se>
	<f22d86810910130158u73c2f669wa129fa4e8d48b521@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonidas . writes:
 > >  > typedef unsigned long           uintptr_t;
 > >  >
 > >  > but intptr_t is not defined at all. Also, isn't above definition
 > >  > incorrect?
 > >
 > > No, it's correct because Linux requires sizeof(void*) == sizeof(long).
 > >
 > >  > Since the whole idea
 > >  > behind uintptr_t is to store pointer in a int sized variable,
 > >
 > > uintptr_t will use _some_ integer type, not necessarily 'int'.
 > >
 > > If ISO C said 'int' there would be no need for {,u}intptr_t.
 > >
 > >  > are we
 > >  > not assuming here that
 > >  >
 > >  > sizeof(int) = sizeof(unsigned long ) on all archs?
 > >
 > > No, see above.
 > >
 > 
 > Thanks, for the response, but frankly I am still confused.
 > Let me recollect my thoughts in more concise manner.
 > 
 > 
 > User space documentation for C99, http://linux.die.net/man/3/intptr_t says,
 > 
 > typedef unsigned int uint16_t
 > typedef uint16_t uintptr_t

That's based on what C99 states, but it's not the definition of uintptr_t
but a specification of the minimal size of that type.  The page you're
referring to fails to mention that.

Anyway, this is not an issue with the kernel.  Please direct C questions
to a C-specific forum, like comp.std.c.  Or google n1124.pdf and read that.
