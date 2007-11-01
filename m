Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbXKAK5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbXKAK5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbXKAK5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:57:38 -0400
Received: from [81.2.110.250] ([81.2.110.250]:34019 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753882AbXKAK5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:57:37 -0400
Date: Thu, 1 Nov 2007 10:59:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata ATAPI transfer size cleanups
Message-ID: <20071101105902.6e411c20@the-village.bc.nu>
In-Reply-To: <4729A23E.7000601@garzik.org>
References: <20071101090733.GA9258@havoc.gtf.org>
	<20071101094344.6eb9d8bc@the-village.bc.nu>
	<4729A23E.7000601@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Nov 2007 05:54:06 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Alan Cox wrote:
> > On Thu, 1 Nov 2007 05:07:33 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> This is purely for comment and testing, not for merging (yet?).
> >>
> >> A common recipe in several vendor drivers (either GPL'd, or I have NDA'd
> >> access to use them as a documentation-like reference) for ATAPI was
> >> slightly different from ours.  This recipe can be found in
> >> atapi_tf_xfer_size(), and it's slightly different from Alan's.
> > 
> > Looks mostly good. Might cause breakage on one or two controllers by
> > setting lbam/lbah to 0 for DMA but we can test that and find out.
> 
> DMA always zeroed lbam/lbah thanks to memset(), my patch merely made it 
> explicit.

That would be a bug if so - need to try fixing that and see if it sorts
out the remaining recalcitrant ALi chips.

Alan
