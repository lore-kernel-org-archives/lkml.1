Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbXFVPEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbXFVPEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbXFVPEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:04:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54511 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618AbXFVPEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:04:33 -0400
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
	[linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in
	zc0301_core.c
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Roman Zippel <zippel@linux-m68k.org>, Oliver Neukum <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706221549280.26568@fbirervta.pbzchgretzou.qr>
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <200706211231.53898.luca.risolia@studio.unibo.it>
	 <200706211326.45031.toralf.foerster@gmx.de>
	 <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota>
	 <20070622134605.GN5193@alberich.amd.com>
	 <Pine.LNX.4.64.0706221549280.26568@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=utf-8
Date: Fri, 22 Jun 2007 12:03:19 -0300
Message-Id: <1182524599.14289.31.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sex, 2007-06-22 às 15:51 +0200, Jan Engelhardt escreveu:
> On Jun 22 2007 15:46, Andreas Herrmann wrote:
> >Hi,
> >
> >I am not sure whether it is related or not
> >But if you select USB as module but build your v4l_usb driver
> >into the kernel you also get compile errors.
> >Attached is a patch which will prevent this by changing the menuconfig
> >from bool to tristate.


> A config option that is not referenced in the Makefile...
> should it really be a tristate? In my opinion, changing it
> to tristate is just a workaround, but I don't know kconfig
> well enough to make bool Do The Right Thing in these situations myself :(

If USB is built as a module, the V4L USB modules should also be built as
a module. Otherwise, you will have compile errors, since some required
symbols on the drivers won't be linked into the kernel.

-- 
Cheers,
Mauro

