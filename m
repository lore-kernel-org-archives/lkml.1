Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbXIONVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbXIONVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 09:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXIONU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 09:20:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39450 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXIONU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 09:20:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46EBDC06.3030202@s5r6.in-berlin.de>
Date: Sat, 15 Sep 2007 15:20:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>,
       James Bottomley <james.bottomley@steeleye.com>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <andi@firstfloor.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
References: <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de> <20070915125055.GQ3563@stusta.de>
In-Reply-To: <20070915125055.GQ3563@stusta.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>>> There should first be the lowlevel SCSI, SATA, USB etc. drivers, these 
>>> drivers should select CONFIG_SCSI, and then the menu offering support 
>>> for disk, CD,...
...
> If users who don't need it now enable CONFIG_SCSI (and drivers/ide/ 
> usage is not that uncommon) that's a regression in the user interface.

Aha, first all interconnects/transports are configured.  If none of them
'select'ed SCSI, the menu for sd, sr, st stays invisible.  Otherwise it
is exposed.

It still doesn't entirely clarify whether users need sd, sr, st, and
whether thy need sd for the disk with root filesystem.
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
