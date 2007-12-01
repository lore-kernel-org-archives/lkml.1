Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbXLAKqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbXLAKqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 05:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXLAKqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 05:46:17 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:45528 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbXLAKqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 05:46:16 -0500
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
From: Marcel Holtmann <marcel@holtmann.org>
To: dsterba@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       akpm@linux-foundation.org, jeff@garzik.org, jkosina@suse.cz,
       jslaby@suse.cz, stephen@symmetric.co.nz, benm@symmetric.co.nz
In-Reply-To: <20071130125555.GA10977@ds.suse.cz>
References: <20071130125555.GA10977@ds.suse.cz>
Content-Type: text/plain
Date: Sat, 01 Dec 2007 11:45:33 +0100
Message-Id: <1196505933.12292.58.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> I'm submitting driver for IPWireless PC Card, used for 4G
> internet connection.
> The driver has been in -mm series as ipwireless_cs.git tree for
> some time, is actively used and there are currently no
> outstanding bugs.
> 
> I'd like to let the driver pass through LKML and then let it
> queue for 2.6.25.
> 
> Driver is released under GPL, original authorship belongs to
> Symmetric co. Jiri Kosina has fixed some bugs and made it work
> with recent kernels, and I work on improving the code to
> match linux kernel standards.
> 
> When merged, please drop ipwireless_cs.git tree from -mm and
> include the patch instead. Patches should be sent to me and I'll
> push them to mainline via Jeff Garzik's driver tree, if there's
> no objection.
> 
> Driver lives in drivers/char/pcmcia directory, it's a serial
> driver.  I'm not sure if this is the right place, since it's a
> networking driver too and therefore should be in
> drivers/net/pcmcia.
> 
> There will be a wiki with info for users and developers, todo etc.
> 
> Regards,
> David Sterba
> 
> Rewieved-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Ben Martel <benm@symmetric.co.nz>
> Signed-off-by: Stephen Blackheath <stephen@symmetric.co.nz>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  MAINTAINERS                                        |    8 
>  drivers/char/pcmcia/Kconfig                        |    8 
>  drivers/char/pcmcia/Makefile                       |    4 
>  drivers/char/pcmcia/ipwireless_cs_hardware.c       | 1728 +++++++++++++++++++++
>  drivers/char/pcmcia/ipwireless_cs_hardware.h       |   63 
>  drivers/char/pcmcia/ipwireless_cs_main.c           |  479 +++++
>  drivers/char/pcmcia/ipwireless_cs_main.h           |   70 
>  drivers/char/pcmcia/ipwireless_cs_network.c        |  496 ++++++
>  drivers/char/pcmcia/ipwireless_cs_network.h        |   54 
>  drivers/char/pcmcia/ipwireless_cs_setup_protocol.h |  108 +
>  drivers/char/pcmcia/ipwireless_cs_tty.c            |  779 +++++++++
>  drivers/char/pcmcia/ipwireless_cs_tty.h            |   48 
>  12 files changed, 3845 insertions(+)

can we please drop the stupid "_cs" stuff. It is an old habit to have
the shortcut for "Card Services" in the driver name, but that goes back
to the time when the PCMCIA subsystem and its drivers were an external
package. Especially in cases where only a PCMCIA card exists, it makes
no sense anymore.

Regards

Marcel


