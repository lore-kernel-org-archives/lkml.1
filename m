Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbXIVJNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbXIVJNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXIVJN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:13:28 -0400
Received: from verein.lst.de ([213.95.11.210]:59318 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbXIVJN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:13:27 -0400
Date: Sat, 22 Sep 2007 11:13:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Olof Johansson <olof@lixom.net>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       hch@lst.de
Subject: Re: [PATCH v2] pcmcia: Convert io_req_t to use kio_addr_t
Message-ID: <20070922091303.GA12525@lst.de>
References: <20070905142742.GA1760@lixom.net> <20070914034854.1658a9cf.akpm@linux-foundation.org> <20070921221516.GA7926@lixom.net> <20070921233936.2aeb2504@the-village.bc.nu> <20070922062551.GE10625@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922062551.GE10625@parisc-linux.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 12:25:51AM -0600, Matthew Wilcox wrote:
> > What about the formatting and field widths ?
> > 
> > ulong would probably be a lot saner than kio_addr_t and yet more type
> > obfuscation.
> 
> I don't think anyone uses ioports > 32bit.  Certainly i386 takes an int
> port as parameter to {in,out}[bwl] (and it really only uses 16-bits).
> parisc uses 24 bits.  I don't know what the various ppcs do, but pci
> bars can only be 32-bit for ioports.  So my opinion is that ioports
> should be uint, not ulong.

The kernel seems to mostly use int, sometimes uint.  I never quite got
why pcmcia had to have it's own strange typedef for them.

