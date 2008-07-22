Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbYGVEeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbYGVEeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYGVEdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:33:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:59975 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYGVEdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:33:45 -0400
Date: Mon, 21 Jul 2008 21:33:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] schedule_timeout_range()
Message-ID: <20080721213327.4b3b440e@infradead.org>
In-Reply-To: <200807221356.29892.nickpiggin@yahoo.com.au>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
	<1216695942.18980.19.camel@shinybook.infradead.org>
	<200807221356.29892.nickpiggin@yahoo.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 13:56:29 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Rather than specific "deadline" values (which we can't guarantee
> anyway), or vague "can defer" values, I would prefer just a small
> selection of maybe orders of magnitude flags, maybe SECONDS,
> MILLISECONDS, MICROSECONDS which gives an amount of delay the kernel
> might add to the timer.

the problem is that many of these are "I'd like a timeout between 30
and ..eh 40 seconds" (think scsi timeouts or networkcard timeouts)

it's not just specific slack units.

> 
-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
