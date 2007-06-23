Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbXFWD4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbXFWD4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 23:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXFWD4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 23:56:47 -0400
Received: from ozlabs.org ([203.10.76.45]:44311 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXFWD4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 23:56:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18044.39404.380472.887065@cargo.ozlabs.ibm.com>
Date: Sat, 23 Jun 2007 13:56:28 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] schedule BLK_DEV_IDE_SATA for removal
In-Reply-To: <20070622101019.0f3b0d3d@the-village.bc.nu>
References: <20070621235211.GH23017@stusta.de>
	<1182483586.10524.33.camel@shinybook.infradead.org>
	<20070622101019.0f3b0d3d@the-village.bc.nu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox writes:

> On Fri, 22 Jun 2007 11:39:45 +0800
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Fri, 2007-06-22 at 01:52 +0200, Adrian Bunk wrote:
> > > Users should use the libata based drivers for SATA drives.
> > 
> > NAK. Not all IDE drivers are converted yet. Not even all the relatively
> > common ones.
> 
> All the common SATA ones are. Just the PowerPC people are falling behind.
> Really we should obsolete powerpc instead ;)

What SATA drive uses a non-libata driver on PowerPC?  In fact the
sata_svw driver used for SATA drives on G5s was one of the early
libata drivers.  Or are you talking about PATA?

Paul.
