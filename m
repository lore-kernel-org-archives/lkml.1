Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbYJ3XEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbYJ3XEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYJ3XEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:04:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59857 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYJ3XEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:04:08 -0400
Date: Fri, 31 Oct 2008 00:03:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Message-ID: <20081030230355.GA918@elte.hu>
References: <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com> <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com> <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin> <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com> <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain> <20081030214910.GA14679@x200.localdomain> <c62985530810301557x2c92a78ay49cdc72931b6caae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810301557x2c92a78ay49cdc72931b6caae@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/10/30 Alexey Dobriyan <adobriyan@gmail.com>:
> > On Thu, Oct 23, 2008 at 08:34:33PM +0400, Alexey Dobriyan wrote:
> >> On Thu, Oct 23, 2008 at 07:27:48PM +0200, Frederic Weisbecker wrote:
> >> > When tracing is enabled, some arch have included <linux/irqflags.h>
> >> > on their <asm/system.h> but others like alpha or m68k don't.
> >> >
> >> > Build error on alpha:
> >> >
> >> > kernel/trace/trace.c: In function 'tracing_generic_entry_update':
> >> > kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
> >
> > FYI, this error still exists in mainline (7f82f000ed030d1108b4de47d9e2d556092980c6).
> >
> 
> Thanks.
> 
> Yes Steven sent a patch to correct it: http://lkml.org/lkml/2008/10/24/205
> But it has not been applied yet (still in discussion?).

i've just applied it to tip/tracing/urgent - should get to Linus 
tomorrow-ish.

	Ingo
