Return-Path: <linux-kernel-owner+w=401wt.eu-S1751297AbZFVEXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbZFVEXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 00:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZFVEXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 00:23:31 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:59435
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750774AbZFVEXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 00:23:31 -0400
Message-ID: <4A3F07C0.9030001@bluewatersys.com>
Date: Mon, 22 Jun 2009 16:25:36 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       spi-devel-general@lists.sourceforge.net, mike@steroidmicros.com,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
References: <4A3F017B.2010409@bluewatersys.com> <20090622041457.GC6027@tarshish>
In-Reply-To: <20090622041457.GC6027@tarshish>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Baruch Siach wrote:
> Hi Ryan,
> 
> On Mon, Jun 22, 2009 at 03:58:51PM +1200, Ryan Mallon wrote:
>> +static int sst25l_erase_block(struct sst25l_flash *flash, u32 offset)
>> +{
>> +	u8 command[4];
>> +	int err;
>> +
>> +	err = sst25l_write_enable(flash, 1);
> 
> Is this enable/disable strictly required for each write/erase? Can't we just 
> enable write once?

The datasheet says that prior to any write/erase instruction the write
enable instruction must be sent.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
