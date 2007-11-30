Return-Path: <linux-kernel-owner+w=401wt.eu-S934546AbXK3NEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546AbXK3NEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbXK3NDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:03:44 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:50178 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934773AbXK3NDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:03:43 -0500
Date: Fri, 30 Nov 2007 08:03:36 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: David Sterba <dsterba@suse.cz>
cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       akpm@linux-foundation.org, jeff@garzik.org, jkosina@suse.cz,
       jslaby@suse.cz, stephen@symmetric.co.nz, benm@symmetric.co.nz
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
In-Reply-To: <20071130125555.GA10977@ds.suse.cz>
Message-ID: <alpine.LFD.0.9999.0711300759200.29812@localhost.localdomain>
References: <20071130125555.GA10977@ds.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, David Sterba wrote:

...
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

might it not make more sense to put all of that into a new
subdirectory, say, /drivers/char/pcmcia/ipwireless_cs?  that way, it's
more modular and it will keep that higher-level directory from
potentially getting cluttered with even more drivers.  and it would
let you drop the pointless "ipwireless_cs_" prefix from all of those
files as well.

rday


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
