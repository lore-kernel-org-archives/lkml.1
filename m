Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXELQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXELQNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXELQNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:13:09 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49956 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbXELQNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:13:08 -0400
Message-ID: <4645E76B.2060704@drzeus.cx>
Date: Sat, 12 May 2007 18:12:27 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <46375B18.4080802@drzeus.cx> <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx> <20070509221253.GC26981@flint.arm.linux.org.uk> <4642B122.5070609@drzeus.cx> <46432502.4050901@drzeus.cx> <alpine.LFD.0.99.0705101037220.24220@xanadu.home> <alpine.LFD.0.99.0705121122440.24220@xanadu.home>
In-Reply-To: <alpine.LFD.0.99.0705121122440.24220@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> Actually, I'm not the author of this workaround.  And looking at it 
> closer, the current workaround is utterly buggy as it completely inhibit 
> CRC error reporting for everything but the listed commands when the MSB 
> of the response is a zero.
>
>   

Your name popped up on the commit for this, but as that was during the
bk days the information was severely lacking.

> Please apply the following patch.  It is compile tested only as I don't 
> have PXA27x hardware with MMC at the moment, but it just cannot be worse 
> than the current code even when it was compiling.
>
>   

I would think that it would be better to look at just MMC_RSP_136 and
MMC_RSP_CRC in case we get future variations.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

