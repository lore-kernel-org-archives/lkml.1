Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbZKWVvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbZKWVvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZKWVvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:51:39 -0500
Received: from ozlabs.org ([203.10.76.45]:49878 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZKWVvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:51:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Tue, 24 Nov 2009 08:21:40 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Ondrej Zary <linux@rainbow-software.org>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>, Jaroslav Kysela <perex@perex.cz>,
       Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
References: <200911222201.59471.linux@rainbow-software.org> <200911231359.54544.rusty@rustcorp.com.au> <s5h8wdxab2h.wl%tiwai@suse.de>
In-Reply-To: <s5h8wdxab2h.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911240821.40563.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 07:10:22 pm Takashi Iwai wrote:
> At Mon, 23 Nov 2009 13:59:53 +1030, Rusty Russell wrote:
> > Two things are required:
> > 1) Modify file2alias to add aliases for isapnp.  This is pretty easy.
> > 2) Expose the isapnp devices in sysfs where udev will match them up
> >    (/sys/bus/isa/devices/<dev>/modalias I guess?)
> 
> There is non-pnp ISA bus, so I'm afraid "isa" may conflict.
> I suppose "isapnp" would be a safer choice.

Without pnp, I don't think you can enumerate the ISA bus. Hence I chose
"isa:" in the hope that udev would "just work" if isapnp created the
modalias under /sys/bus/isa...

But Kay says there's a pnp bus (who knew?).  I don't know what he means
by unfixable aliases tho, since it's all in the kernel source so we can
change it at any time?

Thanks,
Rusty.
