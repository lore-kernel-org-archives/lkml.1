Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYE3Luk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYE3Luk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYE3Luc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:50:32 -0400
Received: from mail.atmel.fr ([81.80.104.162]:38369 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYE3Lub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:50:31 -0400
Message-ID: <483FE9E7.7020707@atmel.com>
Date: Fri, 30 May 2008 13:49:59 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Marc Pignat <marc.pignat@hevs.ch>, Eric BENARD <ebenard@free.fr>,
       Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Anti Sullin <anti.sullin@artecdesign.ee>,
       =?ISO-8859-1?Q?Hans-J=FCrgen_?= =?ISO-8859-1?Q?Koch?= 
	<hjk@linutronix.de>,
       =?ISO-8859-1?Q?Ville_Syrj=E4?= =?ISO-8859-1?Q?l=E4?= 
	<syrjala@sci.fi>
Subject: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

Following your announce of future removal of the MMC multiwrite switch 
and the contributions of several people of the AT91 community, here is a 
patches series :
Those patches should enhance transfer of data and setup a sane base for 
a working SDIO support.

Several of those contributions are around since the beginning of this 
year. I thank all of you for your patient and valuable testing effort. 
Here are some discussions that led to this patch series:

"mmc: at91_mci: support for block size not modulo 4"
http://lists.arm.linux.org.uk/lurker/message/20080107.141550.ea58119f.en.html

AT91 SDIO + 8686
http://lists.arm.linux.org.uk/lurker/message/20071114.094824.3ebcbe04.en.html

"8686 with SDIO on AT91SAM9263"
http://lists.arm.linux.org.uk/lurker/message/20080123.182026.f3c54a8a.en.html

"[PATCH 0/2] at91_mci: manage timeouts"
http://lists.arm.linux.org.uk/lurker/message/20080125.075058.257a2582.en.html

"[PATCH 0/3] at91_mci: fix SD filesystem corruption on sam9261"
http://lists.arm.linux.org.uk/lurker/message/20080318.145450.7b443217.en.html

Regards,
-- 
Nicolas Ferre

