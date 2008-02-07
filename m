Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYBGLQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYBGLQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 06:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbYBGLQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 06:16:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbYBGLQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 06:16:26 -0500
Date: Thu, 7 Feb 2008 06:16:22 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Harald Arnesen <skogtun.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <tomof@acm.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: Latest git oopses during boot
Message-ID: <20080207111622.GA7395@infradead.org>
References: <8120cfd40802060832w2dd3631foad324b3633427230@mail.gmail.com> <20080206144732.5a1a2c3b.akpm@linux-foundation.org> <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com> <20080207020214.0f0cf1c7.akpm@linux-foundation.org> <8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 12:14:56PM +0100, Harald Arnesen wrote:
> > The only recent changes to drivers/scsi/advansys.c are
> >
> > commit b80ca4f7ee36c26d300c5a8f429e73372d153379
> > Author: FUJITA Tomonori <tomof@acm.org>
> > Date:   Sun Jan 13 15:46:13 2008 +0900
> >
> >     [SCSI] replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
> >
> >     This replaces sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE in
> >     several LLDs. It's a preparation for the future changes to remove
> >     sense_buffer array in scsi_cmnd structure.
> >
> >     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

The sense buffer changes have cause a fair amount of trouble, so I'd
look into this one for debugging the problem..

