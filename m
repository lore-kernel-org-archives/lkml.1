Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXK0PdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXK0PdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758596AbXK0PdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:33:10 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:35717 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbXK0PdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:33:07 -0500
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling
	can/will stall forever
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>
In-Reply-To: <1196176294.13982.58.camel@localhost.localdomain>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
	 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
	 <1196176294.13982.58.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 07:25:21 -0800
Message-Id: <1196177122.23808.7.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-27 at 10:11 -0500, Steven Rostedt wrote:
> Thomas,
> 
> Can you ACK or NACK this patch.  I know you play with a bunch of
> hardware that this patch may affect.
> 

My two cents, I think it's needed (or something like it).. It looks like
handle_simple_irq normally expects a custom cascade type handler to
unmask on return. When you switch to a threaded handler the cascade
handler is gone and can't unmask..

Daniel

