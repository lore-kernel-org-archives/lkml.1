Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYERKPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYERKPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 06:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYERKPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 06:15:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59717 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbYERKPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 06:15:34 -0400
Message-ID: <483001C4.1010801@firstfloor.org>
Date: Sun, 18 May 2008 12:15:32 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>, Tom Spink <tspink@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Definitely, but we should do it at the Kconfig level which allows us
> to have integer defines as well, so we end up with something like:
> 
> static inline unsigned int get_nmi_count(int cpu)
> {
>       return CONFIG_X86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
> }

#ifdef CONFIG_X86_64 would evaluate true even with CONFIG_X86_64 == 0

-Andi
