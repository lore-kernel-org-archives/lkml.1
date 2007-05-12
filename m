Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbXELSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbXELSM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbXELSMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:12:50 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbXELSMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:12:49 -0400
Date: Sat, 12 May 2007 11:12:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduled removal of SA_xxx interrupt flags
Message-Id: <20070512111243.aa68b481.akpm@linux-foundation.org>
In-Reply-To: <20070512180703.GA22918@gollum.tnic>
References: <20070512180703.GA22918@gollum.tnic>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 20:07:04 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:

> Hi Andrew,
> 
>    i've been going over the interrupt-handling code and noticed that the SA_xxx
>    interrupt flags are scheduled for removal sometime in 9/2007 with a prior
>    grace period of 6 months for people to fix external stuff. In order to do so,
>    a __deprecated inline function wraps those flags.
>    What puzzles me is that the __deprecated-patches are only in -mm and not in
>    mainline. Is the -mm-testing audience wide enough to cause userspace to fix
>    their apps prior to the SA_xxx removal or am I missing something? I.e,
>    shouldn't tglx's patches hit mainline first?
> 

No, the deprecation is in mainline now

+static inline
+unsigned long __deprecated deprecated_irq_flag(unsigned long flag)
+{
+	return flag;
+}

