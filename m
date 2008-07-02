Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYGBNa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYGBNa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 09:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYGBNaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 09:30:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60223 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbYGBNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:30:15 -0400
Date: Wed, 2 Jul 2008 09:30:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net
Subject: Re: mmap'ed memory in core files ?
Message-ID: <20080702133013.GA1848@infradead.org>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080702105027.GA1111@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702105027.GA1111@frolo.macqel>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 12:50:27PM +0200, Philippe De Muyter wrote:
> Unfortunately, the part that applies to me (I have tested it) is the next one :
> 
>     Memory-mapped I/O pages such as frame buffer are never dumped, [...],
>     regardless of the coredump_filter value.
> 
> Is that a design decision, or a mere finding of the way it is implemented
> now ?

It's an implementation issue, and there are patches queue for 2.6.27
that allow gdb access to these regions, which should be easily
extendable to cover core dumps, too.

