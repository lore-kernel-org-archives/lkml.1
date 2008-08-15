Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbYHOPuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbYHOPuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYHOPtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:49:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:36605 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbYHOPtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:49:53 -0400
Date: Fri, 15 Aug 2008 08:49:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, ak@suse.de,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: remove empty lines from stack traces/oopses
Message-ID: <20080815084934.7f56662e@infradead.org>
In-Reply-To: <20080815152555.GJ10029@elte.hu>
References: <20080731235137.GA4816@martell.zuzino.mipt.ru>
	<20080811170219.GJ4524@elte.hu>
	<20080811192210.GA5791@martell.zuzino.mipt.ru>
	<20080815152555.GJ10029@elte.hu>
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

On Fri, 15 Aug 2008 17:25:55 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > Any recent oops with and without empty lines after Call trace: and 
> > after calltrace.
> 
> ok - i've queued up your fix in tip/x86/debug.
> 
> Arjan, can the removal of empty newlines break the kerneloops.org 
> parser?

nope is fine; the parser isn't that fragile against empty lines
(in fact they get filtered out ;-)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
