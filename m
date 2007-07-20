Return-Path: <linux-kernel-owner+w=401wt.eu-S937828AbXGTRex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937828AbXGTRex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937570AbXGTReJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:34:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55460 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763835AbXGTReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:34:06 -0400
Date: Fri, 20 Jul 2007 18:33:59 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Message-ID: <20070720173359.GA22423@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ralf Baechle <ralf@linux-mips.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
	linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg> <20070720173132.GB19424@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720173132.GB19424@linux-mips.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 06:31:32PM +0100, Ralf Baechle wrote:
> > +#include <asm/irq.h>
> 
> These days that should probably be <linux/irq.h>.

Not at all, linux/irq.h is something entirely different.

