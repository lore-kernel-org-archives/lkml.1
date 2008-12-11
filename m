Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYLKOB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYLKOB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 09:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbYLKOBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 09:01:16 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41990 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755901AbYLKOBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 09:01:15 -0500
Date: Thu, 11 Dec 2008 15:01:12 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Paul Moore <paul.moore@hp.com>
cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [GIT]: Networking
In-Reply-To: <200812110821.00002.paul.moore@hp.com>
Message-ID: <Pine.LNX.4.64.0812111500360.19338@vixen.sonytel.be>
References: <20081208.000655.211323914.davem@davemloft.net>
 <Pine.LNX.4.64.0812111344580.10515@vixen.sonytel.be> <200812110821.00002.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008, Paul Moore wrote:
> On Thursday 11 December 2008 7:50:23 am Geert Uytterhoeven wrote:
> > On Mon, 8 Dec 2008, David Miller wrote:
> > > Here are the pending net fixes:
> > >
> > > 6) netlabel OOPS'er fix from Paul Moore.
> > >
> > > Paul Moore (1):
> > >       netlabel: Fix a potential NULL pointer dereference
> >
> > This introduced:
> > | net/netlabel/netlabel_unlabeled.c:567: warning: 'entry' may be used
> > | uninitialized in this function
> > | net/netlabel/netlabel_unlabeled.c:629: warning: 'entry' may be used
> > | uninitialized in this function
> >
> > which may still oops, if the uninitialized entry pointer is
> > dereferenced (in case list_entry == NULL).
> 
> Hi Geert,
> 
> First of, a quick question: what version of gcc are you using?  I'm 
> using gcc-4.3.2 and I don't get this warning/error.  Regardless, I'll 
> send out a patch later today which should resolve the warning.

I'm using an m68k cross-compiler, built from Debian sources:

| gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
