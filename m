Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZFAJxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZFAJxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbZFAJxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:53:35 -0400
Received: from mail201.messagelabs.com ([216.82.254.211]:63862 "EHLO
	mail201.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbZFAJxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:53:34 -0400
X-VirusChecked: Checked
X-Env-Sender: Luis.Galdos@digi.com
X-Msg-Ref: server-9.tower-201.messagelabs.com!1243850016!37805278!1
X-StarScan-Version: 6.0.0; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Message-ID: <4A23A51C.2000608@digi.com>
Date: Mon, 1 Jun 2009 11:53:32 +0200
From: Luis Galdos <luis.galdos@digi.com>
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [LIBERTAS-SDIO]  Support for single transfer blocks?
References: <4A08392F.70108@digi.com>	 <20090512231150.bc0c65c6.akpm@linux-foundation.org> <1242223408.11182.34.camel@localhost.localdomain>
In-Reply-To: <1242223408.11182.34.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Tue, 2009-05-12 at 23:11 -0700, Andrew Morton wrote:
>> Let's Cc the wireless development list.
> 
> And lets CC the MMC subsystem maintainer and original author of libertas_sdio too, so
> we can get an informed opinion :)
> 
> What firmware version are you using?
The installed firmware version is 9.70.3p24 (downloaded from the Marvell's website).

> What SDIO controller is this?  Has this controller been validated by Marvell for use
> with the 8686? (not that that is required or anything, just curious).
The uC is from Digi (NS9215) and its SDIO-port hasn't been validated by Marvell.

> All the information I have (up to firmware V10) references a block size of 32 bytes.
> The main firmware is transferred in 32-byte blocks using CMD 53, with a maximum number
> of 16 blocks transferred in a single CMD 53 write depending on how much data the helper
> firmware can accept in single write.  The available vendor drivers also use a 32-byte
> block size.
That's right. I only was surprised that the SD8686 accepts data blocks of 512 bytes in a 
single transfer too. This is just nice for SDIO-ports that only support single blocks :) 
(like the NS9215). Anyway, Pierre has informed me that the SD8686 has need of multiple 
blocks support, and the NS9215 doesn't. So, the problem is the controller.


> Dan

Thanks and sorry for the delayed answer (I was on vacations),


-- 
Luis Galdos

