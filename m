Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbXL3SSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbXL3SSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXL3SSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:18:38 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:33065 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbXL3SSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:18:38 -0500
Message-ID: <4777E010.7030703@keyaccess.nl>
Date: Sun, 30 Dec 2007 19:14:40 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl>	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>	<20071230144700.78f4605c@the-village.bc.nu>	<20071230152835.GX16946@elte.hu>	<20071230153818.1a554a7e@the-village.bc.nu>	<20071230160132.GA14311@elte.hu> <20071230164828.039916c8@the-village.bc.nu>
In-Reply-To: <20071230164828.039916c8@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-12-07 17:48, Alan Cox wrote:

> For processors with TSC I think we should aim for 2.6.25 to do this and 
> to have the major other _p fixups done. I pity whoever does stuff like 
> the scc drivers but most of the rest isn't too bad.

I'm by the way looking at drivers/net/wd.c which my 386 uses for its dual 
mode NE2000/WD8013 clone ISA NIC and while it specifically needs no delay at 
all it seems, the mixed use of out and outb_p seems to suggest that someone 
once thought about that. Would you advice sticking in a udelay(2) manually 
there?

Rene.
