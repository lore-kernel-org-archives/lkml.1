Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYGQLLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYGQLLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYGQLLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:11:39 -0400
Received: from www.tglx.de ([62.245.132.106]:38966 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbYGQLLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:11:39 -0400
Date: Thu, 17 Jul 2008 13:11:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard <tuxbox.guru@gmail.com>
cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
In-Reply-To: <487F33F2.2060202@gmail.com>
Message-ID: <alpine.LFD.1.10.0807171306110.4316@apollo.tec.linutronix.de>
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de> <487EECDF.1040401@gmail.com> <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de>
 <487F33F2.2060202@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Richard wrote:
> The Short story... it was a dark and rainy night :-P oops, wrong mailing
> list.... so here goes

Hehe

> The kernel boots and when init.d starts, the screen switches off, the CPU fan
> goes to Max speed, and a few minutes later all goes quiet and it appears to
> have powered off.
> 
> I usually boot with noapictimer and if I disable ACPI totally, the clock
> references don't work and the timebase goes wrong. (Playing a MP3 is quite an
> entertaining event as it sounds like an old vinyl record player with a
> slipping drive belt)

That's with 2.6.25 vanilla, right ? 

Can you provide a bootlog from that kernel with noapictimer on the
kernel command line ?

Also as it reaches at least init it would be great to get a bootlog
for a boot w/o any command line options via netconsole (see
Documentation/networking/netconsole.txt)

Thanks,

	tglx
