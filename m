Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYHYLg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYHYLg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYHYLgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:36:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56628 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYHYLgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:36:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Date: Mon, 25 Aug 2008 13:40:43 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <1219625301.13162.2.camel@pasglop>
In-Reply-To: <1219625301.13162.2.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808251340.44993.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of August 2008, Benjamin Herrenschmidt wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11414
> > Subject		: Random crashes with 2.6.27-rc3 on PPC
> > Submitter	: Michael Buesch <mb@bu3sch.de>
> > Date		: 2008-08-23 14:10 (1 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121950076812616&w=4
> 
> This appears to be a gcc bug when -fno-omit-stack-pointer is used (which
> we mostly don't need on ppc anyway except that another gcc stupidity makes
> it mandatory for -pg which ftrace needs).
> 
> We're working on a two fold workaround: removing -fno-omit-stack-pointer
> in all the cases where we don't really need it, and for when we do (ie,
> CONFIG_FTRACE becaues of -pg), using -mno-sched-epilog which seems to
> work around it.
> 
> The root cause in gcc hasn't been fully identified yet.

Thanks Ben.

I've already dropped it from the list of recent regressions.

Rafael
