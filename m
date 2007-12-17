Return-Path: <linux-kernel-owner+w=401wt.eu-S937468AbXLQXVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937468AbXLQXVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937241AbXLQXUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:20:48 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52501 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937226AbXLQXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:20:45 -0500
Date: Tue, 18 Dec 2007 00:20:44 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
In-Reply-To: <20071216095019.GA12184@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0712180019590.32270@fbirervta.pbzchgretzou.qr>
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
 <20071216095019.GA12184@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 16 2007 18:50, Paul Mundt wrote:
>On Sun, Dec 16, 2007 at 12:21:21AM +0000, Adrian McMenamin wrote:
>> +/* GD Rom registers */
>> +#define GDROM_BASE_REG 0xA05F7000
>> +#define GDROM_ALTSTATUS_REG GDROM_BASE_REG + 0x18
>> +#define GDROM_DATA_REG GDROM_BASE_REG + 0x80
>> +#define GDROM_ERROR_REG GDROM_BASE_REG + 0x84
>> +#define GDROM_INTSEC_REG GDROM_BASE_REG + 0x88
>> +#define GDROM_SECNUM_REG GDROM_BASE_REG + 0x8C
>> +#define GDROM_BCL_REG  GDROM_BASE_REG + 0x90
>> +#define GDROM_BCH_REG GDROM_BASE_REG + 0x94
>> +#define GDROM_DSEL_REG GDROM_BASE_REG + 0x98
>> +#define GDROM_STATUSCOMMAND_REG GDROM_BASE_REG + 0x9C
>> +#define GDROM_RESET_REG GDROM_BASE_REG + 0x4E4
>> +
>> +#define GDROM_DATA_REG_P0 0x005F7080
>> +
>> +#define GDROM_DMA_STARTADDR_REG GDROM_BASE_REG + 0x404
>> +#define GDROM_DMA_LENGTH_REG GDROM_BASE_REG + 0x408
>> +#define GDROM_DMA_DIRECTION_REG GDROM_BASE_REG + 0x40C
>> +#define GDROM_DMA_ENABLE_REG GDROM_BASE_REG + 0x414
>> +#define GDROM_DMA_STATUS_REG GDROM_BASE_REG + 0x418
>> +#define GDROM_DMA_WAIT_REG GDROM_BASE_REG + 0x4A0
>> +#define GDROM_DMA_ACCESS_CTRL_REG GDROM_BASE_REG + 0x4B8
>> +
>These should all be encapsulated by brackets.

Or making it an enum {
	GDROM_DMA_ACCESS_CTL_REG = GDROM_BASE_REG + 0x4B8,
}; without brackets.

