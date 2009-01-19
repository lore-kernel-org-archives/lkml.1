Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbZASWAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbZASWAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZASWA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:00:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42559 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbZASWAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:00:25 -0500
Date: Mon, 19 Jan 2009 22:00:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 07/10] omap mailbox: add save_/restore_ctx() for PM
Message-ID: <20090119220012.GB31848@n2100.arm.linux.org.uk>
References: <20090116082737.17571.53738.stgit@oreo.research.nokia.com> <20090117171044.GE12341@n2100.arm.linux.org.uk> <20090117172037.GF12341@n2100.arm.linux.org.uk> <20090119.123612.153133347.Hiroshi.DOYU@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090119.123612.153133347.Hiroshi.DOYU@nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 12:36:12PM +0200, Hiroshi DOYU wrote:
> Hi Russell, Thank you for your review.
> 
> From: "ext Russell King - ARM Linux" <linux@arm.linux.org.uk>
> Subject: Re: [PATCH 07/10] omap mailbox: add save_/restore_ctx() for PM
> Date: Sat, 17 Jan 2009 17:20:37 +0000
> 
> > On Sat, Jan 17, 2009 at 05:10:44PM +0000, Russell King - ARM Linux wrote:
> > > On Fri, Jan 16, 2009 at 10:27:37AM +0200, Hiroshi DOYU wrote:
> > > > diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
> > > > index a877305..544dde9 100644
> > > > --- a/arch/arm/mach-omap2/mailbox.c
> > > > +++ b/arch/arm/mach-omap2/mailbox.c
> 
> [...]
> 
> > Hmm, don't forget 'i' is an offset not an index, so...
> > 
> > £define MBOX_NR_REGS (MBOX_REG_SIZE / sizeof(u32))
> > 
> > 	for (i = 0; i < MBOX_NR_REGS; i++) {
> > 		p->ctx[i] = mbox_read_reg(i * sizeof(u32));
> 
> The updated one is attached.

... which looks much better, thanks.
