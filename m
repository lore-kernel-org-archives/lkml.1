Return-Path: <linux-kernel-owner+w=401wt.eu-S933650AbZHEMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650AbZHEMHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933562AbZHEMHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:07:19 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:46761 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933504AbZHEMHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:07:18 -0400
Message-ID: <4A7975EB.7020903@mnementh.co.uk>
Date: Wed, 05 Aug 2009 13:07:07 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>	 <4A7053E8.8050303@mnementh.co.uk>	 <20090729201702.GA28202@linux-sh.org>	 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>	 <4A716F1C.2050805@mnementh.co.uk>	 <Pine.LNX.4.64.0907301246330.4462@axis700.grange>	 <4A71F2A5.4060206@mnementh.co.uk>	 <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>	 <4A787C2C.5070000@mnementh.co.uk> <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
In-Reply-To: <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:

> Sorry for not answering your question earlier. This may sound starnge,
> but I don't have any datasheet. I do however think that you can assume
> a 1:1 host/card clock capability, at least to begin with.

Im not so sure I can - the 1:1 clock on MFD is selected via the CNF IO 
area and as such the other users of the driver that dont have CNF areas 
cannot possibly be using this method. Do you have your own method for 
clock selection, or are you using the routine in tmio-mmc.c - if the 
latter then you are certainly not running a 1:1 clock

> So please use the clock framework to enable/disable the clock and get
> the rate, and we'll do our best to adjust the architecture code after
> that. And I'll cook up a patch for Runtime PM on top of that if that's
> ok with you.

I _cant_ use the clock framework by itself in tmio-mmc because that 
would break each and every MFD user of the driver.

-Ian
