Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbYDDU5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbYDDU5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYDDU52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:57:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39030 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYDDU51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:57:27 -0400
Message-ID: <47F69621.3080105@garzik.org>
Date: Fri, 04 Apr 2008 16:57:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.25
References: <alpine.LFD.1.10.0804042019210.3224@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0804042019210.3224@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> 1) drivers/char/hpet.c
>    include/linux/hpet.h
> 
>    due to the revert of the HPET irq assignemt, which was only affects x86.


Related to this...  check out jgarzik/misc-2.6.git#irq-cleanups and 
#irq-remove for my set of patches that remove the 'irq' argument from 
all irq handlers.

I have a couple cleanup patches for HPET that should go in prior to the 
big "remove irq argument" massive change (even if people don't want to 
remove the 'irq' argument ultimately, the cleanup is still useful)

Who is the HPET maintainer these days, if anyone?

	Jeff


