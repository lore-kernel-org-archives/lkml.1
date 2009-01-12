Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbZALLNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbZALLNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZALLMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:12:55 -0500
Received: from styx.suse.cz ([82.119.242.94]:60887 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751003AbZALLMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:12:54 -0500
Date: Mon, 12 Jan 2009 12:12:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
In-Reply-To: <20090112105202.GF10405@elte.hu>
Message-ID: <alpine.LNX.1.10.0901121211000.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz> <20090112105202.GF10405@elte.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009, Ingo Molnar wrote:

> > with Linus' tree (ae04d14015) doesn't build for me with
> > 
> > arch/x86/kernel/ldt.c: In function 'alloc_ldt':
> > arch/x86/kernel/ldt.c:55: error: implicit declaration of function 'paravirt_alloc_ldt'
> > arch/x86/kernel/ldt.c:79: error: implicit declaration of function 'paravirt_free_ldt'
> > 
> > Config on http://www.jikos.cz/jikos/junk/.config
> 
> hm, it builds fine here with your config. Did .28 build fine for you? The 
> only change to this file since .28 has been Jaswinder's "423a540: x86: 
> ldt.c fix style problems".

Puzzled. On one system, I still get this build error even after make 
mrpoper (I use this machine to build kernel routinely, so it certainly 
didn't happen a few days ago). 

But I just tried on different system, and there is builds flawlessly. It's 
gcc 4.3.1 vs 4.3.2. I will check a little bit more.

-- 
Jiri Kosina
SUSE Labs
