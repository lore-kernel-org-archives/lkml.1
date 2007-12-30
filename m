Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbXL3PvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbXL3PvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 10:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbXL3PvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 10:51:08 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:44613 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbXL3PvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 10:51:07 -0500
Message-ID: <4777BDA5.4050203@keyaccess.nl>
Date: Sun, 30 Dec 2007 16:47:49 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu>
In-Reply-To: <20071230152835.GX16946@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-12-07 16:28, Ingo Molnar wrote:

> Reading from the 0x3cc port does not impact the cursor position update 
> sequence IIRC - i think the vidport is even ignored for the input 
> direction by most hardware, there's a separate input register. The 0x3cc 
> port is a well-defined VGA register which should be unused on non-VGA 
> hardware. (which makes it a perfect delay register in any case)

Hardly. Duron 1300 on AMD756:

rene@7ixe4:~/src/port80$ su -c ./port80
cycles: out 2400, in 2401
rene@7ixe4:~/src/port80$ su -c ./port3cc
cycles: out 459, in 394

As stated a few dozen times by now already, port 0x80 is _decidedly_ _non_ 
_random_

Rene.

