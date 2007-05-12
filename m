Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbXELXlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbXELXlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 19:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbXELXlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 19:41:03 -0400
Received: from h155.mvista.com ([63.81.120.158]:51591 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXELXlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 19:41:02 -0400
Subject: Re: [patch] make pit clocksource continuous
From: Daniel Walker <dwalker@mvista.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46464B5C.2080302@aknet.ru>
References: <46464B5C.2080302@aknet.ru>
Content-Type: text/plain
Date: Sat, 12 May 2007 16:38:53 -0700
Message-Id: <1179013133.27889.25.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 03:18 +0400, Stas Sergeev wrote:
> Hello.
> 
> Without the attached patch, I wasn't able
> to get the PIT to work as a clocksource for
> high-res timers.
> I don't know whether the patch is correct,
> but I tested it and it works.
> Can someone please tell me what exactly
> does this flag mean? google reveals nothing
> sensible to me, sorry...
> 
> ---
> Set CLOCK_SOURCE_IS_CONTINUOUS flag for the PIT clocksource

The flag means that the clock doesn't have any help from interrupts to
extend it's precision. In the case of the PIT clocksource it does in
fact use an interrupt (the timer I think) to get a higher precision. It
would be wrong to add the flag in this case.. 

Daniel

