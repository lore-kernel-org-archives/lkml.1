Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYAIUTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYAIUTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYAIUTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:19:24 -0500
Received: from billgribble.com ([65.99.215.30]:44367 "EHLO
	server.billgribble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYAIUTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:19:24 -0500
X-Greylist: delayed 1569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2008 15:19:23 EST
From: Bill Gribble <grib@billgribble.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2 libertas_sdio fails to initialize Marvell SD8686
References: <87bq9x264q.fsf@serrano.home.billgribble.com>
	<20071114190247.4f42aa05@poseidon.drzeus.cx>
Date: Wed, 09 Jan 2008 14:53:58 -0500
In-Reply-To: <20071114190247.4f42aa05@poseidon.drzeus.cx> (Pierre Ossman's
	message of "Wed, 14 Nov 2007 19:02:47 +0100")
Message-ID: <87y7ayvkq1.fsf@billgribble.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Jan  9 13:53:04 2008
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 4785262012631060021202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-mmc@drzeus.cx> writes:
> Marvell tend to not have a one true firmware, but one for each device,
> so you might end up having to dig out the ones shipped with the
> device.

I finally got these firmware files from the manufacturer; still, with
2.6.24-rc6 and the new firmware files, the same errors occur.  

>> Nov 13 14:40:09 pequin kernel: mmc0: starting CMD53 arg 9a000002 flags 000001b5
>> Nov 13 14:40:09 pequin kernel: mmc0:     blksz 32 blocks 2 flags 00000100 tsac 1000 ms nsac 0
>> Nov 13 14:40:09 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
>> Nov 13 14:40:11 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00108000
>> Nov 13 14:40:11 pequin kernel: mmc0: req done (CMD53): 0: 00002000 00000000 00000000 00000000
>> Nov 13 14:40:11 pequin kernel: mmc0:     32 bytes transferred: -110
>
> Your problem is here. The card chokes for some reason and times out
> when it's supposed to receive a chunk of the firmware. Odd, as the
> loading loop first queries the card if it is ready for more data.

Any other sage advice?  I feel like the device is really close to
working, but I just can't get it there!  

Thanks,
Bill Gribble


!DSPAM:4785262012631060021202!


