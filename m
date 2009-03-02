Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbZCBR5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbZCBR5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZCBR5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:57:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:53849 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZCBR5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:57:03 -0500
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
References: <1235996477.5330.174.camel@laptop>
	 <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 18:56:51 +0100
Message-Id: <1236016611.5330.971.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 09:11 -0800, Linus Torvalds wrote:

<story about how PIO IDE sucks>

> So this is not as simple as your patch. Not even _nearly_.

Yuckness, yes that does complicate matters significantly. 

That leaves us trying to find all request_irq() invocations that do not
have IRQF_DISABLED.. /me puts it on the todo list.

