Return-Path: <linux-kernel-owner+w=401wt.eu-S1763776AbYEGWER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763776AbYEGWER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbYEGWD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:03:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44589 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbYEGWDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:03:55 -0400
Message-ID: <48222742.5040008@firstfloor.org>
Date: Thu, 08 May 2008 00:03:46 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Mirco Tischler <mt-ml@gmx.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG]:WARNING: at arch/x86/kernel/rtc.c:122 in 2.6.26-rc1
References: <1210183536.28099.10.camel@mtlp.tischlernetz>	 <alpine.LFD.1.10.0805072102010.3318@apollo.tec.linutronix.de>	 <1210188734.5456.14.camel@mtlp.tischlernetz>	 <alpine.LFD.1.10.0805072253480.3318@apollo.tec.linutronix.de> <1210196777.26103.8.camel@mtlp.tischlernetz>
In-Reply-To: <1210196777.26103.8.camel@mtlp.tischlernetz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> May  7 21:52:04 kernel: [4294896.091827] Extended CMOS year: 2000
> May  7 21:52:04 kernel: [4294896.091827] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> May  7 21:52:04 kernel: [4294896.091827] Back to C!
> May  7 21:52:04 kernel: [4294896.091827] Extended CMOS year: 2000

If the data is read correctly (and it looks like it) then just the bit
is wrong and we should ignore it I guess. So just remove the
WARN_ON_ONCE()?

-Andi

