Return-Path: <linux-kernel-owner+w=401wt.eu-S1423326AbXDYJIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423326AbXDYJIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423339AbXDYJIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:08:04 -0400
Received: from smtp25.orange.fr ([193.252.22.21]:53016 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423326AbXDYJIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:08:02 -0400
X-ME-UUID: 20070425090800305.4A85C1C000BB@mwinf2536.orange.fr
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Xavier Bestel <xavier.bestel@free.fr>
To: nigel@nigel.suspend2.net
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Christian Hesse <mail@earthworm.de>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1177491047.3857.32.camel@nigel.suspend2.net>
References: <200704182245.24156.mail@earthworm.de>
	 <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de>
	 <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz>
	 <1177490913.30284.38.camel@frg-rhel40-em64t-04>
	 <1177491047.3857.32.camel@nigel.suspend2.net>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 11:07:52 +0200
Message-Id: <1177492072.30284.48.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 18:50 +1000, Nigel Cunningham wrote:
> > (And guess what, it uses APM and suspend is really faster and way more
> > reliable than each kernel implementation I could try).
> 
> If you tried Suspend2 and had problems with reliability, please send me
> logs. I'll do all I can to help. (I have to qualify it a bit, because
> I'm not able to fix drivers, but if it's a Suspend2 issue, tell me and
> I'll fix it).

Does suspend2 work with APM ? After much trying, I think now the ACPI
implementation of my laptop (a vintage Compaq Armada 1700) is busted,
only APM works.

AFAIR the problem with suspend2 was that it didn't poweroff some parts
of the laptop (the led of the wifi pcmcia card was on, and the lcd light
was on too), but that was last year. Kernel's suspend kind of worked but
didn't resume (no reaction on button press). As I tried all this last
year, I may have forgotten some things.
Honestly, I like this laptop when it works flawlessly, so I don't see
many reasons to try *susp* again. I'll do it when I'm bored, just not
today.

Thanks,
	Xav


