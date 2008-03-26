Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYCZDDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYCZDDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYCZDDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:03:39 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59404 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751281AbYCZDDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:03:39 -0400
Date: Tue, 25 Mar 2008 22:03:38 -0500
From: Jack Steiner <steiner@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 6/8] x86_64: Define the macros and tables for the basic UV infrastructure.
Message-ID: <20080326030338.GB11714@sgi.com>
References: <20080324182118.GA21758@sgi.com> <87ej9zi05c.fsf@basil.nowhere.org> <20080326000930.GB18701@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326000930.GB18701@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 08:09:30PM -0400, Christoph Hellwig wrote:
> On Tue, Mar 25, 2008 at 11:11:11AM +0100, Andi Kleen wrote:
> > Not sure what physical mode is.
> > 
> > > +#ifdef __BIOS__
> > > +#define UV_ADDR(x)		((unsigned long *)(x))
> > > +#else
> > > +#define UV_ADDR(x)		((unsigned long *)__va(x))
> > > +#endif
> > 
> > But it it would be cleaner if your BIOS just supplied a suitable __va()
> > and then you remove these macros.
> 
> the bios should just have headers of it's own instead of placing this
> burden on kernel code.

See mail from earlier today. The UV_ADDR macro has been eliminated.


--- jack
