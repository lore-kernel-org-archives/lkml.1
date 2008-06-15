Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYFOLNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYFOLNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 07:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbYFOLNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 07:13:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52431 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbYFOLNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 07:13:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
Date: Sun, 15 Jun 2008 13:14:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <19f34abd0806141509m18f9f959v94fbeb27e42aa0ed@mail.gmail.com>
In-Reply-To: <19f34abd0806141509m18f9f959v94fbeb27e42aa0ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806151314.43568.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 15 of June 2008, Vegard Nossum wrote:
> On Sat, Jun 14, 2008 at 10:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > If you know of any other unresolved regressions from 2.6.25, please let me know
> > either and I'll add them to the list.  Also, please let me know if any of the
> > entries below are invalid.
> 
> http://lkml.org/lkml/2008/6/14/62
> 
> was just reported today. Seems to have been caused by
> 
> commit 3ac7fe5a4aab409bd5674d0b070bce97f9d20872
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Apr 30 00:55:01 2008 -0700
> 
>     infrastructure to debug (dynamic) objects
> 
> which was introduced just after v2.6.25, but not discovered until now,
> probably because it requires the (admittedly obscure) combination of
> lockdep and slub/object debugging.

Added to the list as http://bugzilla.kernel.org/show_bug.cgi?id=10918 .

Thanks,
Rafael
