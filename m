Return-Path: <linux-kernel-owner+w=401wt.eu-S1761995AbXJQL0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995AbXJQL0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbXJQL0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:26:34 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:45464 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757937AbXJQL0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:26:33 -0400
X-Greylist: delayed 1169 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 07:26:33 EDT
Date: Wed, 17 Oct 2007 13:07:02 +0200
From: Martin Mares <mj@ucw.cz>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Understanding lspci output
Message-ID: <mj+md-20071017.110231.1634.nikam@ucw.cz>
References: <4715D119.7000508@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4715D119.7000508@free.fr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> I ran lspci -vvv on a system:
> http://linux.kernel.free.fr/halt/lspci.txt
> 
> (I used lspci version 2.2.5 in case it matters.)
> 
> But I'm having a hard time making sense of the output.
> 
> 1. How many PCI buses are there in the system?

Two, just see the bus numbers of the devices. (However, there might be
additional buses with no devices present and in case these are connected
to a separate host bridge, they need not be visible.)

> 4. Does the system have a PCI-X bus?

Yes, the devices on bus 01 are PCI-X devices, so there is a PCI-X bus.

> 2. Do any of the PCI buses support 66 MHz operation?

Yes, PCI-X does.

> 3. Do any of the PCI slots support 64-bit data path?

This cannot be inferred from the lspci output -- there is no way how to
tell if a bus has physical slots or it exists only internally.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
hAS ANYONE SEEN MY cAPSLOCK KEY?
