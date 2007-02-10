Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbXBJWur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbXBJWur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXBJWur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:50:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52888 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXBJWuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:50:46 -0500
Date: Sat, 10 Feb 2007 22:50:33 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't configured
Message-ID: <20070210225033.GO10050@ftp.linux.org.uk>
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com> <45CE0434.30105@gmail.com> <20070210194630.GA13416@osiris.ibm.com> <45CE43B5.2020806@gmail.com> <Pine.LNX.4.64.0702101425230.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702101425230.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 02:25:53PM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 10 Feb 2007, Tejun Heo wrote:
> > 
> > I think an arch needs to support ioport_map/unmap and noncoherent dma (just
> > alias to coherent interface on x86/amd64) interface whether PCI is implemented
> > or not.  No?
> 
> We haven't required ioport implementations in the past, afaik.

We don't even require ioremap().  What the hell could it possibly mean on
e.g. UML?  The same goes for DMA.  And yes, of course it means that a lot
of drivers are not buildable on it - hardly a surprise, that...
