Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYANPvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYANPvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYANPvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:51:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36041 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYANPvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:51:45 -0500
Date: Mon, 14 Jan 2008 16:51:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Isolate PIC/PIT in/out calls
Message-ID: <20080114155124.GA14177@elte.hu>
References: <20080111181846.5ead1220@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111181846.5ead1220@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0073]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Rather than remove and/or mangle inb_p/outb_p we want to remove the 
> use of them from inappropriate places. For the PIC/PIT this may 
> eventually depend on 32/64bitism or similar so start by adding 
> inb/outb_pit and inb/outb_pic so that we can make them use any scheme 
> we settle on without disturbing the existing, correct (for ISA), port 
> 0x80 usage. (eg we can make inb_pit use udelay without messing up 
> inb_p).
> 
> Floppy already does this for the fdc. That really only leaves the CMOS 
> as a core logic item to tackle, and bits of parallel port handling in 
> the chipset layers.

thanks, applied.

	Ingo
