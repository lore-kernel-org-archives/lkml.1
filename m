Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbXEQOrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbXEQOrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXEQOr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:47:28 -0400
Received: from neopsis.com ([213.239.204.14]:38401 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753169AbXEQOr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:47:27 -0400
Message-ID: <464C708C.6090808@dbservice.com>
Date: Thu, 17 May 2007 17:11:08 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
References: <464C5FAC.8060609@dbservice.com> <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.365,
	required 5, autolearn=spam, AWL 0.23, BAYES_00 -2.60)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 17 May 2007, Tomas Carnecky wrote:
> 
>> Despite it's a Microsoft product, it's actually very nice and useful. A 
>> little pad with a few buttons and connectors for a headset. It's an USB 
>> device, but it doesn't represent itself as an input/HID device:
>>    HID device not claimed by input or hiddev
>
> Could you please 
> 
> - compile the kernel with CONFIG_HID_DEBUG and send me the output you 
>   receive when you connect the device

usb 2-5: new low speed USB device using ohci_hcd and address 4
usb 2-5: configuration #1 chosen from 1 choice
drivers/hid/usbhid/hid-core.c: report descriptor (size 61, read 61) =
05 0b 09 05 a1 01 05 09 19 11 29 18 15 00 25 01 75 01 95 08 81 22 05 08
09 3a a1 02 05 09 19 11 29 17 15 00 25 01 75 01 95 07 b1 a2 c0 06 ff ff
09 01 15 00 25 01 75 01 95 01 b1 22 c0
drivers/hid/hid-core.c: report (size 1) (unnumbered)
drivers/hid/hid-core.c: report 0 (size 1) =  00
hid-debug: input Button.0011 = 0
hid-debug: input Button.0012 = 0
hid-debug: input Button.0013 = 0
hid-debug: input Button.0014 = 0
hid-debug: input Button.0015 = 0
hid-debug: input Button.0016 = 0
hid-debug: input Button.0017 = 0
hid-debug: input Button.0018 = 0
drivers/hid/hid-core.c: report (size 1) (unnumbered)
drivers/hid/hid-core.c: report 0 (size 1) =  00
hid-debug: input Button.0011 = 0
hid-debug: input Button.0012 = 0
hid-debug: input Button.0013 = 0
hid-debug: input Button.0014 = 0
hid-debug: input Button.0015 = 0
hid-debug: input Button.0016 = 0
hid-debug: input Button.0017 = 0
hid-debug: input Vendor-specific-FF.0001 = 0
  INPUT[INPUT]
    Field(0)
      Usage(8)
        Button.0011
        Button.0012
        Button.0013
        Button.0014
        Button.0015
        Button.0016
        Button.0017
        Button.0018
      Logical Minimum(0)
      Logical Maximum(1)
      Report Size(1)
      Report Count(8)
      Report Offset(0)
      Flags( Variable Absolute NoPrefferedState )
  FEATURE[FEATURE]
    Field(0)
      Logical(LED.003a)
      Usage(7)
        Button.0011
        Button.0012
        Button.0013
        Button.0014
        Button.0015
        Button.0016
        Button.0017
      Logical Minimum(0)
      Logical Maximum(1)
      Report Size(1)
      Report Count(7)
      Report Offset(0)
      Flags( Variable Absolute NoPrefferedState Volatile )
    Field(1)
      Usage(1)
        Vendor-specific-FF.0001
      Logical Minimum(0)
      Logical Maximum(1)
      Report Size(1)
      Report Count(1)
      Report Offset(7)
      Flags( Variable Absolute NoPrefferedState )
HID device not claimed by input or hiddev

