Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbXIBECS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbXIBECS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 00:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbXIBECJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 00:02:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51315 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbXIBECI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 00:02:08 -0400
X-Sasl-enc: xVswniSdVIDSOyGfEj+8iXklS/U7A1KDvvtGNHNX7LmY 1188705726
Date: Sun, 2 Sep 2007 01:02:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeff Garzik <jeff@garzik.org>
Cc: Shane <shane@cm.nu>, linux-kernel@vger.kernel.org
Subject: Re: intel-rng on modern hardware
Message-ID: <20070902040203.GA16520@khazad-dum.debian.net>
References: <20070901194426.GA32713@csy.ca> <46D9CE20.9060603@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D9CE20.9060603@garzik.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Sep 2007, Jeff Garzik wrote:
> Shane wrote:
>> Just wondering if there is a newer version of intel-rng out
>> of tree or whether modern Intel chipsets have a usable RNG. I haven't been 
>> able to get intel-rng loading (no such
>> device) on anything from the p965, p975 or p35 chipsets.
>
> No modern ICH chipset has an RNG, AFAIK.

No ICH ever had one.

The i810 era Intel RNG is in the FWH (the firmware hub, aka BIOS FLASH
chip).  You can have it anywhere someone uses an original Intel 82802AB or
82802AC FWH, no matter the chipset (the FWH is a LPC device).

But you have to be lucky enough to get a Intel FWH, and one that has the RNG
inside working.  I doubt Intel is producing them anymore, but you could ask
them.  The last board I know of that had those *if you were lucky* was the
D875PBZ.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
