Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYEaJ0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYEaJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 05:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYEaJ0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 05:26:15 -0400
Received: from server.drzeus.cx ([85.8.24.28]:46430 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750840AbYEaJ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 05:26:14 -0400
Date: Sat, 31 May 2008 11:26:06 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: mulix@mulix.org
Cc: linux-kernel@vger.kernel.org
Subject: looping S/PDIF data
Message-ID: <20080531112606.5884a1c9@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a minor annoyance with the snd_trident driver that I was hoping
you might have a fix for:

Pausing the output does not seem to take on the S/PDIF output. Analog
outputs properly stop in their tracks, but the S/PDIF port keeps
looping the current data buffer, which gives a rather unpleasant end
result. :)

Also, I was wondering if the hardware is capable of automatically
shuffling data from the line in ADC to the S/PDIF port? The driver
doesn't expose anything, but I don't know if that's because of missing
code or missing hardware.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
