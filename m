Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbYHZNq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbYHZNq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYHZNqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:46:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:51063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbYHZNqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:46:19 -0400
Date: Tue, 26 Aug 2008 06:46:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Tony Luck" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: PATCH] debug: add notifier chain debugging
Message-ID: <20080826064617.0c0fd340@infradead.org>
In-Reply-To: <12c511ca0808252208n29043ab0lf9e56f94d5e4cb37@mail.gmail.com>
References: <20080815152938.4bc9d48c@infradead.org>
	<12c511ca0808251539w6f00a216s86a09a532c553a34@mail.gmail.com>
	<20080825215555.2331f2cc@infradead.org>
	<12c511ca0808252208n29043ab0lf9e56f94d5e4cb37@mail.gmail.com>
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

On Mon, 25 Aug 2008 22:08:00 -0700
"Tony Luck" <tony.luck@intel.com> wrote:

> >> This breaks on ia64 (and pa-risc I think) where function pointers
> >> don't point directly at the code, they point to a {code,data}
> >> structure which is itself located in data space, not text space.
> >
> > is there a way to go to the actual address? I'm sure this is a bit
> > more common.... (like kallsyms!)
> 
> See dereference_function_descriptor() in lib/vsprintf.c (where it will
> be clear that my memory was wrong and that PPC64 is the other
> architecture that needs this).
> 
> Perhaps this needs to be moved to some place in asm-generic so
> that it can be used by code like your sanity check?

or we make a func_is_kernel_text() thast maps underneath...
after all that'll be a common use of this function ;)

> 
> -Tony


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
