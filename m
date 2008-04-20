Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbYDTNGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbYDTNGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 09:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYDTNG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 09:06:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55529 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYDTNG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 09:06:28 -0400
Message-ID: <480B3FCF.1090207@firstfloor.org>
Date: Sun, 20 Apr 2008 15:06:23 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu>
In-Reply-To: <20080420124717.GH8474@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:

> Clearly if I have the choice between a kernel which can run 50k threads
> and a kernel which does not crash under me during an I/O error, I choose
> the later! I don't even imagine what purpose 50k kernel threads may serve.

I don't know either but it was quoted to me earlier as the primary
reason 4k stacks were introduced.

> I have nothing against changing the default setting to 4k provided that
> it is easy to get back to the save setting

So you're saying that only advanced users who understand all their
CONFIG options should have the safe settings? And everyone else
the "only explodes once a week" mode?

For me that is exactly the wrong way around.

If someone is sure they know what they're doing they can set whatever
crazy settings they want (given there is a quick way to check
for the crazy settings in oops reports so that I can ignore those), but
the default should be always safe and optimized for reliability.

-Andi

