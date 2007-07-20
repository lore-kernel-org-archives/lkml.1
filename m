Return-Path: <linux-kernel-owner+w=401wt.eu-S934308AbXGTRqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbXGTRqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936374AbXGTRqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:46:31 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:44269 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936293AbXGTRq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:46:28 -0400
Date: Fri, 20 Jul 2007 18:46:23 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Message-ID: <20070720174623.GA5547@linux-mips.org>
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg> <20070720173132.GB19424@linux-mips.org> <20070720173359.GA22423@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720173359.GA22423@infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 06:33:59PM +0100, Christoph Hellwig wrote:

> On Fri, Jul 20, 2007 at 06:31:32PM +0100, Ralf Baechle wrote:
> > > +#include <asm/irq.h>
> > 
> > These days that should probably be <linux/irq.h>.
> 
> Not at all, linux/irq.h is something entirely different.

Well, fine.  But checkpatch.pl will bitch about this and other files.
So one way or the other it's not quite kosher.

  Ralf
