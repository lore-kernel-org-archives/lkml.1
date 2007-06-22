Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbXFVPqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbXFVPqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbXFVPqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:46:18 -0400
Received: from ns1.suse.de ([195.135.220.2]:49291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500AbXFVPqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:46:17 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
Date: Fri, 22 Jun 2007 17:45:51 +0200
User-Agent: KMail/1.9.7
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, LKML <linux-kernel@vger.kernel.org>
References: <200706211117.55908.toralf.foerster@gmx.de> <Pine.LNX.4.64.0706221549280.26568@fbirervta.pbzchgretzou.qr> <1182524599.14289.31.camel@gaivota>
In-Reply-To: <1182524599.14289.31.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706221745.52083.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 22. Juni 2007 schrieb Mauro Carvalho Chehab:
> Em Sex, 2007-06-22 às 15:51 +0200, Jan Engelhardt escreveu:
> > On Jun 22 2007 15:46, Andreas Herrmann wrote:
> > >Hi,
> > >
> > >I am not sure whether it is related or not
> > >But if you select USB as module but build your v4l_usb driver
> > >into the kernel you also get compile errors.
> > >Attached is a patch which will prevent this by changing the menuconfig
> > >from bool to tristate.
> 
> 
> > A config option that is not referenced in the Makefile...
> > should it really be a tristate? In my opinion, changing it
> > to tristate is just a workaround, but I don't know kconfig
> > well enough to make bool Do The Right Thing in these situations myself :(
> 
> If USB is built as a module, the V4L USB modules should also be built as
> a module. Otherwise, you will have compile errors, since some required
> symbols on the drivers won't be linked into the kernel.

Yes, and if you build USB statically, you can build the video drivers
statically or as modules. The config language must reflect that. I
don't it is possible to represent that with a bool.

	Regards
		Oliver
