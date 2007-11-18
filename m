Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbXKRRUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbXKRRUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 12:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXKRRUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 12:20:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35908 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXKRRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 12:20:45 -0500
Date: Sun, 18 Nov 2007 09:18:28 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, tglx@tglx.de
Subject: Re: [patch] Printk kernel version in WARN_ON
Message-ID: <20071118091828.4dc0dbbd@laptopd505.fenrus.org>
In-Reply-To: <20071117165719.c8d7bb48.akpm@linux-foundation.org>
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
	<20071117102720.251107d7.akpm@linux-foundation.org>
	<20071117103947.5b2052f8@laptopd505.fenrus.org>
	<20071117104652.8240af62.akpm@linux-foundation.org>
	<20071117113501.5e3e0d43@laptopd505.fenrus.org>
	<20071118004218.GA26865@elte.hu>
	<20071117165719.c8d7bb48.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 16:57:19 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Should be done for all architectures, methinks.
> 
> If so, an appropriate way to do that would be to do
> s/dump_stack/arch_dump_stack/ and do a single all-arch implementation
> of dump_stack().  (Where we might add new goodies in the future).
> 
> Problem is that this will add a new an pointless entry to all the
> stack dumps, unless the arch_dump_stack() implementation is smart
> enough to skip the innermost frame.

it also adds a stackframe to the "oh my god I'm low on stack space lets
get a dump out" codepath ;(

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
