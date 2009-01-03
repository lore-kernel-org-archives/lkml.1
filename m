Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbZACWIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbZACWIB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759809AbZACWHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:07:50 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:38510 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbZACWHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:07:49 -0500
Message-ID: <ac3eb2510901031407m68230817u9a491d982026a5fe@mail.gmail.com>
Date: Sat, 3 Jan 2009 23:07:46 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Andreas Mohr" <andi@lisas.de>
Subject: Re: cannot reliably detect USB device
Cc: "Wu Fengguang" <fengguang.wu@intel.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090101174453.GA3805@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225104753.GB15733@localhost>
	 <20090101174453.GA3805@rhlx01.hs-esslingen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2009 at 18:44, Andreas Mohr <andi@lisas.de> wrote:
>> > > I have a pl2303 USB-RS232 converter that cannot be reliably
>> > > detected.
>> >
>> > Faulty hardware?  Flaky cables?  Bad connections?  If this is
>> > reproducable for the same device on multiple machines, I'd just go buy
>> > a
>> > new device :)
>>
>> I decided to give it a last try before planning a replacement - then I
>> find that /dev/ttyUSB0 could be created if I enlarge the retry times.
>>
>> It could take 10 seconds to get a valid response. It must go crazy.
>
> Detected _instantly_ on 2.6.28 here:
>
> [59750.560209] usb 1-1: USB disconnect, address 5
> [59750.561888] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
> [59750.561970] pl2303 1-1:1.0: device disconnected
> [59752.904108] usb 1-1: new full speed USB device using uhci_hcd and address 6
> [59753.059546] usb 1-1: configuration #1 chosen from 1 choice
> [59753.061460] pl2303 1-1:1.0: pl2303 converter detected
> [59753.114738] usb 1-1: pl2303 converter now attached to ttyUSB0
>
> (the 3-second delay basically was me waiting before reinserting)
>
>
> Bus 001 Device 006: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
>
> Label: "GMUS-03 USB Serial Adapter"
>
> Detection test only, _not_ used for actual serial communication currently...
>
>
> But there are more PL2303 adapters than flies on this planet,
> thus someone else also has some input on this?

Mine works fine with today's Linux git tree:
  usb 1-2.2: new full speed USB device using uhci_hcd and address 11
  usb 1-2.2: configuration #1 chosen from 1 choice
  pl2303 1-2.2:1.0: pl2303 converter detected
  usb 1-2.2: pl2303 converter now attached to ttyUSB0

Kay
