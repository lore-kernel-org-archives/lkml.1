Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXBKIWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXBKIWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 03:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbXBKIWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 03:22:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53485 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbXBKIWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 03:22:18 -0500
Date: Sun, 11 Feb 2007 08:21:59 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>, Tejun Heo <htejun@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [patch] linux/io.h: forward declare struct pci_dev
Message-ID: <20070211082159.GT10050@ftp.linux.org.uk>
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com> <20070211034902.GA9077@infradead.org> <45CEB720.1020406@gmail.com> <20070211063431.GS10050@ftp.linux.org.uk> <20070211071047.GA3847@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211071047.GA3847@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 07:10:47AM +0000, Christoph Hellwig wrote:
> On Sun, Feb 11, 2007 at 06:34:31AM +0000, Al Viro wrote:
> > +config NO_IOPORT
> > +	bool
> > +	default n
> 
> please make this IOPORT.  config symbols with an implicit negation
> are quite horrible for the brain to understand.

Take a look at lib/Kconfig.  And see HAS_IOPORT there.

The reason for doing it that way: majority of targets has that stuff
already.  Even more should have it eventually.  IOW, the default should
be positive.  Modified in arch/*/Kconfig of targets where it doesn't
work.  Which is exactly what's done here.
