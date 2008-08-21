Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbYHUTe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbYHUTe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbYHUTeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:34:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215AbYHUTeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:34:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Date: Thu, 21 Aug 2008 21:37:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com> <200808212113.53411.rjw@sisk.pl> <19f34abd0808211216q319e4fbclc41b362d8dbdcbc0@mail.gmail.com>
In-Reply-To: <19f34abd0808211216q319e4fbclc41b362d8dbdcbc0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212137.52757.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, Vegard Nossum wrote:
> On Thu, Aug 21, 2008 at 9:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> ...followed by the "unable to handle kernel paging request" as in
> >> previous e-mail. The numbers 00100104 and 00200200 seem to appear all
> >> the time.
> >>
> >> At least it is 100% reproducible now and with nice oopses too :-)
> >
> > Hm, slab corruption, it seems.
> >
> > Do you use SLAB or SLUB?
> 
> SLUB, with all possible debugging:
> 
> CONFIG_SLUB_DEBUG=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> CONFIG_SLABINFO=y
> CONFIG_SLUB_DEBUG_ON=y
> CONFIG_SLUB_STATS=y
> 
> (Thanks for helping out.)

(You're welcome.)

Can you switch to SLAB and retest?  I don't really think SLUB is the issue
here, but SLAB may give us additional information.

Thanks,
Rafael
