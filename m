Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYERIdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYERIdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 04:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYERIdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 04:33:32 -0400
Received: from gw.goop.org ([64.81.55.164]:50070 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbYERIdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 04:33:31 -0400
Message-ID: <482FE9CA.4090804@goop.org>
Date: Sun, 18 May 2008 09:33:14 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <20080518073804.GB6948@cvg>
In-Reply-To: <20080518073804.GB6948@cvg>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> I think I would prefer Maciej's advice then but with capital
> letters (to easy distinguish them and point an attention) like
>
> #ifdef CONFG_X86_64
> #define CPU_64 1
> #else
> #define CPU_64 0
> #endif

The other problem in this case is that cpu_pda() doesn't exit for 
32-bit, so it probably won't compile anyway.  But in general, I fully 
support using if (constant) over #ifdef (?: not so much).

    J
