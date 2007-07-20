Return-Path: <linux-kernel-owner+w=401wt.eu-S1762055AbXGTOAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055AbXGTOAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXGTOAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:00:39 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:59263 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXGTOAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:00:39 -0400
Date: Fri, 20 Jul 2007 16:00:36 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Pierre Savary" <pierre.savary@kerlink.fr>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: TR: Neep help with my MMC driver ...
Message-ID: <20070720160036.581f8fba@poseidon.drzeus.cx>
In-Reply-To: <000c01c7cad4$127dcba0$377962e0$@savary@kerlink.fr>
References: <000c01c7cad4$127dcba0$377962e0$@savary@kerlink.fr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
To: s@drzeus.cx
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 15:44:18 +0200
"Pierre Savary" <pierre.savary@kerlink.fr> wrote:

> Hi,
> 
>  
> 
> I permit me to send you a mail because I've seen on the net that you
> have work around MMC.

Well, I am the maintainer ;)

Also, you should include the LKML for these discussions.

> 
> Linux 2.6.21+patch.AT91 run on my AT91sam9260. I must use the MMC.
> But it doesn't work . and I try since the begin of this week !!!!!!!!
> This is what I do :
> 
>  

*snip*

> 
> $ mknod /dev/mmc b 254 0
> 

Make sure this is the correct major. You can find it in /proc/devices.

*snip*

> 
> Sending command 1 as 00001041, arg = 00000000, blocks = 0, length = 0
> (MR = 00008384)
> 
> setting ier to 00000001
> 
> MCI irq: status = 0001C0E4, C07F0001, 00010000
> 
> MMC: Response index error
> 
> Completed command
> 
> Status = 0009C0E4 [00000000 00000000 00000000 00000000]
> 
> Error detected and set to 4 (cmd = 1, retries = 0)
> 
> mmc0: req done (CMD1): 4/0/0: 00000000 00000000 00000000 00000000
> 
> mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
> 
> MMC: Setting controller bus width to 1
> 

All your commands are failing, oddly enough with "response index
error". I'm not familiar with the AT91 controller, so I'm adding
Nicolas Ferre, the AT91 maintainer, to this discussion.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
