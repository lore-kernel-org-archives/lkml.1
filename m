Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYHZE4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYHZE4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 00:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYHZEz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 00:55:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:54774 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYHZEz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 00:55:59 -0400
Date: Mon, 25 Aug 2008 21:55:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Tony Luck" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: PATCH] debug: add notifier chain debugging
Message-ID: <20080825215555.2331f2cc@infradead.org>
In-Reply-To: <12c511ca0808251539w6f00a216s86a09a532c553a34@mail.gmail.com>
References: <20080815152938.4bc9d48c@infradead.org>
	<12c511ca0808251539w6f00a216s86a09a532c553a34@mail.gmail.com>
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

On Mon, 25 Aug 2008 15:39:13 -0700
"Tony Luck" <tony.luck@intel.com> wrote:

> On Fri, Aug 15, 2008 at 3:29 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > +       if (!kernel_text_address((unsigned long)n->notifier_call)) {
> > +               WARN(1, "Invalid notifier registered!");
> > +               return 0;
> > +       }
> 
> This breaks on ia64 (and pa-risc I think) where function pointers
> don't point directly at the code, they point to a {code,data}
> structure which is itself located in data space, not text space.

is there a way to go to the actual address? I'm sure this is a bit more
common.... (like kallsyms!)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
