Return-Path: <linux-kernel-owner+w=401wt.eu-S935932AbXLQLYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935932AbXLQLYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935341AbXLQLYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:24:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764192AbXLQLYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:24:36 -0500
Date: Mon, 17 Dec 2007 03:22:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Sterba <dsterba@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH V2] ipwireless_cs driver for 4G PC Card
Message-Id: <20071217032222.af86c830.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712171155130.12449@jikos.suse.cz>
References: <20071130125555.GA10977@ds.suse.cz>
	<20071212150851.GB10118@ds.suse.cz>
	<Pine.LNX.4.64.0712171155130.12449@jikos.suse.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 11:57:46 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrote:

> [ CC list trimmed ] 

often a bad idea...

> On Wed, 12 Dec 2007, David Sterba wrote:
> 
> > Changelog:
> > * files moved to ipwireless/, ipwireless_cs_ stripped from filenames
> > * _cs stripped from driver name
> > * kmalloc checks
> > * sync irq during shutdown
> > * removed /proc code, converted to module params
> > 
> > When merged, please drop ipwireless_cs.git tree from -mm and
> > include the patch instead.
> > 
> > Regards,
> > David Sterba
> > 
> > Rewieved-by: Jiri Slaby <jslaby@suse.cz>
> > Signed-off-by: Ben Martel <benm@symmetric.co.nz>
> > Signed-off-by: Stephen Blackheath <stephen@symmetric.co.nz>
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> >  MAINTAINERS                                     |    8 
> >  drivers/char/pcmcia/Kconfig                     |    9 
> >  drivers/char/pcmcia/Makefile                    |    2 
> >  drivers/char/pcmcia/ipwireless/Makefile         |   10 
> >  drivers/char/pcmcia/ipwireless/hardware.c       | 1784 ++++++++++++++++++++++++
> >  drivers/char/pcmcia/ipwireless/hardware.h       |   63 
> >  drivers/char/pcmcia/ipwireless/main.c           |  496 ++++++
> >  drivers/char/pcmcia/ipwireless/main.h           |   70 
> >  drivers/char/pcmcia/ipwireless/network.c        |  513 ++++++
> >  drivers/char/pcmcia/ipwireless/network.h        |   54 
> >  drivers/char/pcmcia/ipwireless/setup_protocol.h |  108 +
> >  drivers/char/pcmcia/ipwireless/tty.c            |  687 +++++++++
> >  drivers/char/pcmcia/ipwireless/tty.h            |   48 
> >  13 files changed, 3852 insertions(+)
> 
> Andrew, what is your position on merging this into your 2.6.25 queue 
> please? David has fixed all the issues that came up during review, so it 
> seems to be that it's time for the driver to be merged during the upcoming 
> merge window.
> 
> If you take it, I am perfectly fine with you dropping the 
> ipwireless_cs git tree from -mm lineup.
> 

I'd have thought that you'd merge it into git-ipwireless_cs.patch and that
you would then take care of merging it into mainline at an appropriate
time?

