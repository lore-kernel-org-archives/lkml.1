Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYGNEe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYGNEe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 00:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYGNEeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 00:34:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbYGNEeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 00:34:19 -0400
Date: Sun, 13 Jul 2008 21:33:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org
Subject: Re: Remove init_mm export as planned for 2.6.26
Message-Id: <20080713213322.f9f5550e.akpm@linux-foundation.org>
In-Reply-To: <20080714023709.GA12795@infradead.org>
References: <20080711201959.GA1007@redhat.com>
	<20080711193046.89b4b68a.akpm@linux-foundation.org>
	<20080714023709.GA12795@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 22:37:09 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Jul 11, 2008 at 07:30:46PM -0700, Andrew Morton wrote:
> > > -EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */
> > >  
> > >  /*
> > >   * Initial thread structure.
> > > 
> > 
> > grep -r init_mm include/asm-sparc64
> > 
> > This patch used to break stuff.  I'm not aware that anything was done
> > to prevent this.
> 
> Dave's patch only unexprts it on x86, which per defintion can't break
> sparc64 which is known to need this export.

What, you want beauty _and_ reading comprehension?

>  It would be nice if someone
> could do a little audit which architectures require it in addition to
> sparc64 and remove it fromm all others.

Yup.  afaik sparc64 is the only one.
