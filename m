Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYGNCh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYGNCh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYGNChV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:37:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYGNChU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:37:20 -0400
Date: Sun, 13 Jul 2008 22:37:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org
Subject: Re: Remove init_mm export as planned for 2.6.26
Message-ID: <20080714023709.GA12795@infradead.org>
References: <20080711201959.GA1007@redhat.com> <20080711193046.89b4b68a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711193046.89b4b68a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 07:30:46PM -0700, Andrew Morton wrote:
> > -EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */
> >  
> >  /*
> >   * Initial thread structure.
> > 
> 
> grep -r init_mm include/asm-sparc64
> 
> This patch used to break stuff.  I'm not aware that anything was done
> to prevent this.

Dave's patch only unexprts it on x86, which per defintion can't break
sparc64 which is known to need this export.  It would be nice if someone
could do a little audit which architectures require it in addition to
sparc64 and remove it fromm all others.
