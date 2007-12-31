Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbXLaSUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbXLaSUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXLaSUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:20:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42639 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbXLaSU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:20:28 -0500
Message-ID: <4779329A.5070305@zytor.com>
Date: Mon, 31 Dec 2007 10:19:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "David P. Reed" <dpreed@reed.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl>	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>	<20071230144700.78f4605c@the-village.bc.nu>	<20071230152835.GX16946@elte.hu>	<20071230153818.1a554a7e@the-village.bc.nu>	<20071230160132.GA14311@elte.hu>	<20071230164828.039916c8@the-village.bc.nu>	<4777E010.7030703@keyaccess.nl>	<20071230183927.5a5a3c42@the-village.bc.nu>	<4777F297.9070207@keyaccess.nl>	<alpine.LFD.1.00.0712301158410.32517@woody.linux-foundation.org>	<47780B93.4050606@reed.com>	<20071230213623.410d480a@the-village.bc.nu>	<4778266B.2060502@reed.com>	<47783678.9070706@zytor.com> <20071231115902.72ab8fe7@the-village.bc.nu>
In-Reply-To: <20071231115902.72ab8fe7@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 30 Dec 2007 16:23:20 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>>> continuing to investigate for a cause.  It would be nice if it were a 
>>> BIOS-fixable problem.  It would be even nicer if the BIOS were GPL...
>> If it was an SMM trap, I would expect it to be trapped in the SuperIO chip.
> 
> Many SuperIO chips do port 0x80, but they do it over the LPC and they do
> it in hardware to the parallel port data lines. The timings posted for
> 0x80 on his box are really a bit fast for LPC.

Ah, that would eliminate the SuperIO chip.

	-hpa
