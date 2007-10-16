Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbXJPEN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbXJPEN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 00:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbXJPENr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 00:13:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35245 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXJPENq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 00:13:46 -0400
Date: Mon, 15 Oct 2007 21:11:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: david@lang.hm, Greg KH <greg@kroah.com>, Rob Landley <rob@landley.net>,
       Julian Calaby <julian.calaby@gmail.com>, Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071015211116.0fc24692@laptopd505.fenrus.org>
In-Reply-To: <20071016040401.GA15744@parisc-linux.org>
References: <200710112011.22000.rob@landley.net>
	<200710150304.00901.rob@landley.net>
	<646765f40710150206j75af4c4dwac4f4565451b64b1@mail.gmail.com>
	<200710150508.37332.rob@landley.net>
	<20071015173357.GB5738@kroah.com>
	<Pine.LNX.4.64.0710151952250.3949@asgard.lang.hm>
	<20071016040401.GA15744@parisc-linux.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 22:04:01 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Mon, Oct 15, 2007 at 07:54:22PM -0700, david@lang.hm wrote:
> > do PCI devices reorder their bus numbers spontaniously, or only if
> > you change the hardware?
> 
> The only system I've had that reordered PCI bus numbers was when I
> had a partitionable system and changed the partitioning.  Not quite
> "change the hardware", but neither was it "spontaneous".  It was
> certainly unexpected (for me).
> 

a very common one is booting your laptop docked (a real dock, not just
a port extender) versus non-docked....
