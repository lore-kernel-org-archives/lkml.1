Return-Path: <linux-kernel-owner+w=401wt.eu-S1423310AbXDYItB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423310AbXDYItB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423306AbXDYItB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:49:01 -0400
Received: from smtp20.orange.fr ([193.252.22.29]:51201 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423310AbXDYItA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:49:00 -0400
X-ME-UUID: 20070425084858269.41D621C000AA@mwinf2017.orange.fr
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Xavier Bestel <xavier.bestel@free.fr>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070425072350.GA6866@ucw.cz>
References: <200704182245.24156.mail@earthworm.de>
	 <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de>
	 <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 10:48:33 +0200
Message-Id: <1177490913.30284.38.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 07:23 +0000, Pavel Machek wrote:
> > I absolutely detest all suspend-to-disk crap. Quite frankly, I hate the 
> > whole thing. I think they've _all_ caused problems for the "true" suspend 
> > (suspend-to-ram), and the last thing I want to see is three or four 
> 
> Well, it is a bit more complex than that.
> 
> suspend-to-disk is a workaround for
> 
>         'suspend-to-ram eats too much power' (plus some details like
>         being able to replace battery).
> 
> suspend-to-ram is a workaround for
> 
>         'idle machine takes way too much power' (plus some details
>         like don't spin the disk so that machine is safe to carry).

I think it depends on who you ask. I personally think that suspend-to-
$youchoose is a workaround for the slowness of system startup. I never
turn off my laptop, I just suspend it.

(And guess what, it uses APM and suspend is really faster and way more
reliable than each kernel implementation I could try).

	Xav


