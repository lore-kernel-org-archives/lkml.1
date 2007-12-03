Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbXLCTg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbXLCTg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXLCTgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:36:51 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:50283 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbXLCTgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:36:50 -0500
Subject: Re: [PATCH] isapnp driver semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org
In-Reply-To: <20071203164751.GB16135@elte.hu>
References: <20071203153743.119714913@mvista.com>
	 <20071203155753.GA32546@elte.hu>
	 <1196697144.1568.1.camel@jnielson-xp.ddns.mvista.com>
	 <20071203164751.GB16135@elte.hu>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 11:25:28 -0800
Message-Id: <1196709928.1568.16.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-03 at 17:47 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Mon, 2007-12-03 at 16:57 +0100, Ingo Molnar wrote:
> > > * Daniel Walker <dwalker@mvista.com> wrote:
> > > 
> > > > Changed the isapnp semaphore to a mutex.
> > > 
> > > cool - i'll give it a whirl.
> > > 
> > > small immaterial nit:
> > > 
> > > > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> > > 
> > > it's Signed-off-by (note the capitalization). Having this consistent 
> > > makes scripting around patches a tiny bit easier.
> > 
> > Yeah, I know about it but sometimes still slips by..
> 
> it's worth automating these repetative bits. I use small templates when 
> creating patches. Also, it's worth running patches through 
> scripts/checkpatch.pl - it has a check for exactly this typo. [ Not a 
> big issue at all, i just mentioned it in case you get a taste for 
> sending more sem2mutex patches :-) ]


These are the patches, and files I've touched so far in case anyone is
working on this .. These are all to be submitted.

unix98-semaphore-to-mutex.patch
	linux-2.6.23/drivers/char/tty_io.c
spi-semaphore-to-mutex.patch
	linux-2.6.23/drivers/spi/spi.c
au1000-semaphore-to-mutex.patch
	linux-2.6.23/drivers/pcmcia/au1000_generic.c
soc_common-semaphore-to-mutex.patch
	linux-2.6.23/drivers/pcmcia/soc_common.c
	linux-2.6.23/drivers/pcmcia/soc_common.h
qla2xxx-semaphore-to-mutex.patch
	linux-2.6.23/drivers/scsi/qla2xxx/qla_os.c
bcm43xx-semaphore-to-mutex.patch
	linux-2.6.23/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
adb_handler_sem-to-mutex.patch
	linux-2.6.23/drivers/macintosh/adb.c

Daniel

