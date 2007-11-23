Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbXKWVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbXKWVxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbXKWVxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 16:53:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41084 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbXKWVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 16:53:08 -0500
Date: Fri, 23 Nov 2007 13:52:12 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Cc: "David Woodhouse" <dwmw2@infradead.org>, "Bryan Wu" <bryan.wu@analog.com>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/1] [MTD/NAND]: Add Blackfin BF52x on-chip NAND Flash
 controller driver support in bf5xx_nand driver
Message-ID: <20071123135212.7c483aae@laptopd505.fenrus.org>
In-Reply-To: <386072610711230625k23b68e49q6090b7eb27c2c039@mail.gmail.com>
References: <1195812893-26312-1-git-send-email-bryan.wu@analog.com>
	<1195813178.25590.35.camel@pmac.infradead.org>
	<386072610711230625k23b68e49q6090b7eb27c2c039@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007 22:25:29 +0800
"Bryan Wu" <cooloney.lkml@gmail.com> wrote:

> On Nov 23, 2007 6:19 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> >
> > On Fri, 2007-11-23 at 18:14 +0800, Bryan Wu wrote:
> > >
> > > +#ifdef CONFIG_BF54x
> > >         /* Setup DMAC1 channel mux for NFC which shared with SDH
> > > */ val = bfin_read_DMAC1_PERIMUX();
> > >         val &= 0xFFFE;
> > >         bfin_write_DMAC1_PERIMUX(val);
> > >         SSYNC();
> > > -
> > > +#endif
> >
> > You can't build a multiplatform kernel which runs on BF52x and
> > BF54x?
> 
> There are some hardware difference between BF52x and BF54x. We have
> to do this.
> 

well does it need to be an #ifdef, or can it be a runtime if() ?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
