Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbXDZBZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbXDZBZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbXDZBZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:25:24 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:46028 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbXDZBZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Wd8R89Q20wIyLYvyyeBtZ05LxM6HQMIYEEf0q/zcKjZPk5Ajm37IsopJ+jy9jKEklAOLbRQF8X03fPEJcrYE5v8b+8RNB9A3ePC4k+WgE7N8W/qFSGAkfs4QPcJK1h7CgkDqaXDjYdre/zV1vIJuoKZ4iaijxpddfOS+LXz9JNE=
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070425192512.GZ3468@stusta.de>
References: <20070419070437.GA25211@elte.hu>
	 <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de>
	 <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de>
	 <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
	 <20070425192512.GZ3468@stusta.de>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 09:25:02 +0800
Message-Id: <1177550702.4685.10.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 21:25 +0200, Adrian Bunk wrote:
> On Wed, Apr 25, 2007 at 11:50:45AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 25 Apr 2007, Adrian Bunk wrote:
> > > 
> > > 3W for the complete system? In CPU state S1? [1]
> > 
> > In STR, 3W is quite realistic. The CPU is off, all (or most - up to you) 
> > the devices are off, but the motherboard and memory is powered.
> 
> As far as I understand it, the CPU isn't off in S1.
> 
> > > And even 3W would still be a waste of energy.

It is, especially if you're living in a place where power infrastructure
is unreliable (such as where I live). Currently, because of the summer
heat, power demand exceeds power supply so we experience practically
daily rotating 4-hour power interruption. 

That 3W saved multiplied by the total number of computers is a lot.
In this perspective, S2D (or shutdown) is preferred over S2RAM.

Tony


