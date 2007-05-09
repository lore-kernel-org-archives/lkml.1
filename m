Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXEITHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXEITHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbXEITHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:07:25 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44850 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbXEITHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:07:24 -0400
Message-ID: <46421BB5.7040504@drzeus.cx>
Date: Wed, 09 May 2007 21:06:29 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <46375B18.4080802@drzeus.cx> <20070509185636.GB26981@flint.arm.linux.org.uk>
In-Reply-To: <20070509185636.GB26981@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> Dug out from the ARM kautobuild...
>
> drivers/mmc/host/pxamci.c: In function 'pxamci_cmd_done':
> drivers/mmc/host/pxamci.c:236: error: 'MMC_ALL_SEND_CID' undeclared (first use in this function)
> drivers/mmc/host/pxamci.c:236: error: (Each undeclared identifier is reported only once
> drivers/mmc/host/pxamci.c:236: error: for each function it appears in.)
> drivers/mmc/host/pxamci.c:237: error: 'MMC_SEND_CSD' undeclared (first use in this function)
> drivers/mmc/host/pxamci.c:238: error: 'MMC_SEND_CID' undeclared (first use in this function)
>
>   

What are opcode defines doing in the driver?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

