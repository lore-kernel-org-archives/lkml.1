Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYGQME1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYGQME1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYGQMET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:04:19 -0400
Received: from www.tglx.de ([62.245.132.106]:45934 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYGQMES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:04:18 -0400
Date: Thu, 17 Jul 2008 14:03:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard <tuxbox.guru@gmail.com>
cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
In-Reply-To: <487F39AC.3060805@gmail.com>
Message-ID: <alpine.LFD.1.10.0807171400090.4316@apollo.tec.linutronix.de>
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de> <487EECDF.1040401@gmail.com> <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de>
 <487F33F2.2060202@gmail.com> <alpine.LFD.1.10.0807171306110.4316@apollo.tec.linutronix.de> <487F39AC.3060805@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Richard wrote:
> Prepare to be spammed.... I am using a Sabayon build, but all distros I have
> tried exibit the same behavior to me. the nohz=off options also works quite
> well. (I have a 2.6.26 vanilla that behaves the same)
> 
> but for now, I am off to read and setup the netconsole.

Thanks for the boot log. That looks familiar:

> Jul 14 11:12:23 localhost [ 0.098984] ..MP-BIOS bug: 8254 timer not connected
> to IO-APIC

We have a fix for that in Linus tree. Any chance to give current
mainline a test ride ?

Thanks,

	tglx
