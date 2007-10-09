Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbXJIGMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbXJIGMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXJIGMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:12:41 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:6276 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbXJIGMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:12:40 -0400
Message-ID: <470B1BBF.3020203@sw.ru>
Date: Tue, 09 Oct 2007 10:12:15 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>, devel@openvz.org
Subject: Re: irq0 stops working
References: <470B1119.8040207@sw.ru> <Pine.LNX.4.64.0710090733410.14524@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710090733410.14524@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 9 2007 09:26, Vasily Averin wrote:
>> On one of our servers timer interrupts (i.e irq0) are stops working. As result
>> any kernel timers do not triggers and tasks waiting some signals from timers
>> hangs forever.
> 
> What kernel.. and tried CONFIG_NO_HZ=n?

Originally I've noticed this issue on RHEL5 kernels, but then I've reproduced it
on latest mainstream kernels, in my last attempt it was 2.6.23-rc7.

Thank you for for your tips about  CONFIG_NO_HZ=n, will try to to it.

thank you,
	Vasily Averin

OpenVZ Linux Kernel Team
