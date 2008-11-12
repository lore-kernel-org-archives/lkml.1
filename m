Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbYKLIu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbYKLIu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYKLIur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:50:47 -0500
Received: from [69.90.0.18] ([69.90.0.18]:60431 "EHLO mtl.rackplans.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYKLIur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:50:47 -0500
Date: Wed, 12 Nov 2008 03:51:17 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pavel Machek <pavel@suse.cz>, mathias.schnarrenberger@gmx.de,
       Olaf van der Spek <olafvdspek@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: security: delete BIOS password in keyboard buffer during kernel
 bootup
In-Reply-To: <20081111165421.4f1e836d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0811120349370.16188@mtl.rackplans.net>
References: <200811081100.03966.mathias.schnarrenberger@gmx.de> <b2cc26e40811080839i387e5e94o519a5d1ff0086379@mail.gmail.com> <200811090941.20401.mathias.schnarrenberger@gmx.de> <20081109110814.13a4c099@lxorguk.ukuu.org.uk> <20081111161808.GA4473@ucw.cz>
 <20081111165421.4f1e836d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Alan Cox wrote:

> Date: Tue, 11 Nov 2008 16:54:21 +0000
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> To: Pavel Machek <pavel@suse.cz>
> Cc: mathias.schnarrenberger@gmx.de, Olaf van der Spek <olafvdspek@gmail.com>,
>     linux-kernel@vger.kernel.org
> Subject: Re: security: delete BIOS password in keyboard buffer during kernel
>     bootup
> 
> > OTOH we don't call BIOS from linux, so we assume that low 64K is
> > usable memory (unless marked otherwise in memmap, I guess).
> 
> We use the BIOS in some cases for PCI routing, PCI services, APM, and
> indirectly for SMM traps, ACPI and via user space for other stuff. So we
> preserve the bottom 4K for the BIOS 0x40:xx page
> > 
> > Anyway, proper place to do clearing is bootloader; it interacts with
> > bios already, anyway...
> 
> Agreed entirely.

Best place would be for the OEM to fix it.  If it's a security issue it 
shouldn't be overly difficult to embarass them into a fix.

	Gerhard
 
--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
