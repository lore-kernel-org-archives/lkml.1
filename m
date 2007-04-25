Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbXDYBHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbXDYBHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 21:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbXDYBHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 21:07:04 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3885 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbXDYBHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 21:07:00 -0400
Date: Wed, 25 Apr 2007 03:06:59 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425010659.GB63747@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
	Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
	Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arjan van de Ven <arjan@infradead.org>
References: <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 04:41:58PM -0700, Linus Torvalds wrote:
> How many different magic ioctl's does the thing introduce? Is it really 
> just *two* entry-points (and how simple are they, interface-wise), and 
> nothing else?

Aren't you a little late to the party here?  The userland version is
the one that currently is in the kernel, after all the people who said
"doing it in userland is not necessarily a good idea" got happily
ignored.  Suspend2 which is the continuity of the fully-in-kernel one
is the one that has been constantly rejected by Pavel, lately by
saying "it should be done in userspace", and hence never merged.

Incidentally, it's 13 ioctls, and it's documented in
Documentation/power/userland-swsusp.txt in a hard drive near you.  I
especially like the "get the available swap space in bytes" one that
can only handle 32 bits.

  OG.
