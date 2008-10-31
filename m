Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYJaIu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYJaIu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 04:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYJaIuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 04:50:13 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:33903 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYJaIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 04:50:10 -0400
Date: Fri, 31 Oct 2008 09:50:06 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
In-Reply-To: <20081030214910.GA14679@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0810310949190.22521@anakin>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
 <20081023121145.GB27984@x200.localdomain> <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
 <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin>
 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
 <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com>
 <20081023163433.GA3160@x200.localdomain> <20081030214910.GA14679@x200.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Alexey Dobriyan wrote:
> On Thu, Oct 23, 2008 at 08:34:33PM +0400, Alexey Dobriyan wrote:
> > On Thu, Oct 23, 2008 at 07:27:48PM +0200, Frederic Weisbecker wrote:
> > > When tracing is enabled, some arch have included <linux/irqflags.h>
> > > on their <asm/system.h> but others like alpha or m68k don't.
> > > 
> > > Build error on alpha:
> > > 
> > > kernel/trace/trace.c: In function 'tracing_generic_entry_update':
> > > kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
> 
> FYI, this error still exists in mainline (7f82f000ed030d1108b4de47d9e2d556092980c6).

Now it hit mainline (I can't be bothered to develop _new_ code to fix things in
-next ;-), I'm implementing irqs_disabled_flags() for m68k. Stay tuned...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
