Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYFPUCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYFPUCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYFPUC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:02:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60055 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYFPUCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:02:25 -0400
Message-ID: <4856C6C8.6060506@garzik.org>
Date: Mon, 16 Jun 2008 16:02:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
References: <1213609751.26255.673.camel@pmac.infradead.org> <20080616115950.41bc65aa@lxorguk.ukuu.org.uk>
In-Reply-To: <20080616115950.41bc65aa@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 16 Jun 2008 10:49:11 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
>> Converted with help from Jaswinder Singh
>>
>> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
>> ---
>>  drivers/char/Kconfig           |    7 +
>>  drivers/char/ip2/fip_firm.h    | 2149 ----------------------------------------
>>  drivers/char/ip2/ip2base.c     |    5 +-
>>  drivers/char/ip2/ip2main.c     |   45 +-
>>  firmware/Makefile              |    1 +
>>  firmware/WHENCE                |   10 +
>>  firmware/intelliport2.bin.ihex | 2147 +++++++++++++++++++++++++++++++++++++++
>>  7 files changed, 2201 insertions(+), 2163 deletions(-)
>>  delete mode 100644 drivers/char/ip2/fip_firm.h
>>  create mode 100644 firmware/intelliport2.bin.ihex
> 
> Fine by me. I've not checked all the digits are correct but the rest of
> the logic seems clean enough
> 
> Acked-by: Alan Cox <alan@redhat.com>

Except for the part where the firmware is pointlessly separated from the 
driver.

We do not need two parallel driver hierarchies, one for firmware, one 
for C source.

	Jeff




