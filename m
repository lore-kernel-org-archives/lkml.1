Return-Path: <linux-kernel-owner+w=401wt.eu-S1761187AbYCZAJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbYCZAJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757081AbYCZAJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:09:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbYCZAJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:09:36 -0400
Date: Tue, 25 Mar 2008 20:09:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jack Steiner <steiner@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 6/8] x86_64: Define the macros and tables for the basic
	UV infrastructure.
Message-ID: <20080326000930.GB18701@infradead.org>
References: <20080324182118.GA21758@sgi.com> <87ej9zi05c.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ej9zi05c.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 11:11:11AM +0100, Andi Kleen wrote:
> Not sure what physical mode is.
> 
> > +#ifdef __BIOS__
> > +#define UV_ADDR(x)		((unsigned long *)(x))
> > +#else
> > +#define UV_ADDR(x)		((unsigned long *)__va(x))
> > +#endif
> 
> But it it would be cleaner if your BIOS just supplied a suitable __va()
> and then you remove these macros.

the bios should just have headers of it's own instead of placing this
burden on kernel code.
