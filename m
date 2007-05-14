Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbXENJ6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbXENJ6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbXENJ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:58:27 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58738 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbXENJ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:58:26 -0400
Message-ID: <4648329D.1070903@drzeus.cx>
Date: Mon, 14 May 2007 11:57:49 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mike Rapoport <mike@compulab.co.il>, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: pxamci.c fails to compile
References: <46481C2C.8030402@compulab.co.il> <20070514091433.GA13199@flint.arm.linux.org.uk>
In-Reply-To: <20070514091433.GA13199@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Mon, May 14, 2007 at 11:22:04AM +0300, Mike Rapoport wrote:
>> The PXA MMC controller does not compile for PXA27x after MMC
>> reorganization, because it uses protocol defines to implement HW erratum
>> workaround (lines 232 - 247 of drivers/mmc/host/pxamci.c ).
>> The following patch fixes it
> 
> It's been discussed over the last few days, and the conclusion that has
> been reached is that the work-around is in fact itself buggy.  The real
> fix should be merged soon.
> 

Indeed. I have the fix ready to go. I was hoping I could get some fix for at91
aswell, but that doesn't seem to be happening so I'll push in a bit.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
