Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbXGCJJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbXGCJJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 05:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXGCJJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 05:09:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:33654 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbXGCJJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 05:09:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LyLiBYhgextSKEOcJHyA2HEmsH9IET2O2YqbBLRgOFyE3XnVG07oYH83u0oaOBnn9ciV/WJgav39QZ5QKY4EyiUE42WTL4olKZAbgIMMGdN5eUrVhO940gDwhuZvadezhACkDG9L+5iak70XAC9PN7+Cc9TZLd5+8KjHkZfZxfo=
Message-ID: <4dde4acb0707030209n7b3b9236q2619a67f5c4dad5e@mail.gmail.com>
Date: Tue, 3 Jul 2007 14:39:40 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: Fwd: Mounting MMC card
Cc: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4684E8C2.7050109@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>
	 <4684CDCC.9030202@drzeus.cx>
	 <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>
	 <4684D358.9090402@drzeus.cx>
	 <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
	 <4684DEF3.5060103@drzeus.cx>
	 <4dde4acb0706290357x54d3ea32vaf75d5cfe638cb25@mail.gmail.com>
	 <4684E65F.2070202@drzeus.cx>
	 <4dde4acb0706290406v204fb87eif0e5fbae17636593@mail.gmail.com>
	 <4684E8C2.7050109@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

   This is referring to my problem - not able to mount MMC card. I
have some output from dmesg when I remove and put the card back (I
have changes the kernel config to include i.MX SPI and disabled the
generic SPI). DOes this give any clue as to why the MMC card is not
appaering in /proc/partions and /sysfs/block ??  Any help will of
great use. The output of dmesg is as follows. I have removed and
inserted the card twice.


<6>imx-mmc imx-mmc.0: card removed
<7>imx-mmc imx-mmc.0: clock 0 power 1 vdd 20 width 1
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>MMC: starting cmd 00 arg 00000000 flags 00000040
<7>imx-mmc imx-mmc.0: CMD00 (0x00) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (00): 1: 00000000 00000000 00000000 00000000
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x80000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 80000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 01 arg 00000000 flags 00000061
<7>imx-mmc imx-mmc.0: CMD01 (0x01) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (01): 1: 00000000 00000000 00000000 00000000
<7>imx-mmc imx-mmc.0: clock 0 power 0 vdd 0 width 1
<6>imx-mmc imx-mmc.0: card inserted
<7>imx-mmc imx-mmc.0: clock 0 power 1 vdd 20 width 1
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>MMC: starting cmd 00 arg 00000000 flags 00000040
<7>imx-mmc imx-mmc.0: CMD00 (0x00) mask set to 0x003b
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 0
<7>MMC: req done (00): 0: 00000000 00000000 00000000 00000000
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00008000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00008000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 01 arg 00000000 flags 00000061
<7>imx-mmc imx-mmc.0: CMD01 (0x01) mask set to 0x003b
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 0
<7>MMC: req done (01): 0: 00000000 00000000 00000000 00000000
<7>imx-mmc imx-mmc.0: clock 0 power 0 vdd 0 width 1
<6>imx-mmc imx-mmc.0: card removed
<7>imx-mmc imx-mmc.0: clock 0 power 1 vdd 20 width 1
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>MMC: starting cmd 00 arg 00000000 flags 00000040
<7>imx-mmc imx-mmc.0: CMD00 (0x00) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (00): 1: 00000000 00000000 00000000 00000000
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 01 arg 00000000 flags 00000061
<7>imx-mmc imx-mmc.0: CMD01 (0x01) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (01): 1: 00000000 00000000 00000000 00000000
<7>imx-mmc imx-mmc.0: clock 0 power 0 vdd 0 width 1
<6>imx-mmc imx-mmc.0: card inserted
<7>imx-mmc imx-mmc.0: clock 0 power 1 vdd 20 width 1
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>MMC: starting cmd 00 arg 00000000 flags 00000040
<7>imx-mmc imx-mmc.0: CMD00 (0x00) mask set to 0x003b
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 0
<7>MMC: req done (00): 0: 00000000 00000000 00000000 00000000
<7>imx-mmc imx-mmc.0: clock 150000 power 2 vdd 20 width 1
<7>imx-mmc imx-mmc.0: PERCLK2 265977856 MHz -> prescaler 5
<7>imx-mmc imx-mmc.0: MMC_CLK_RATE: 0x00000057
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 37 arg 00000000 flags 00000015
<7>imx-mmc imx-mmc.0: CMD55 (0x37) mask set to 0x003b
<7>imx-mmc imx-mmc.0: CMD TIMEOUT
<7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
0x00000000, error 1
<7>MMC: req done (37): 1: 00000000 00000000 00000000 00000000
<7>MMC: starting cmd 01 arg 00000000 flags 00000061
<7>imx-mmc imx-mmc.0: CMD01 (0x01) mask set to 0x003b
<7>imx-mmc imx-mmc.0: RESP 0x00008000, 0x00000000, 0x00000000,
0x00000000, error 0
<7>MMC: req done (01): 0: 00008000 00000000 00000000 00000000
<7>imx-mmc imx-mmc.0: clock 0 power 0 vdd 0 width 1


Thanks,
Midhun.
