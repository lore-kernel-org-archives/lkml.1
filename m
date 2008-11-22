Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbYKVWi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbYKVWi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYKVWiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:38:14 -0500
Received: from lucidpixels.com ([75.144.35.66]:48960 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbYKVWiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:38:11 -0500
Date: Sat, 22 Nov 2008 17:38:10 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Moore, Eric" <Eric.Moore@lsi.com>
cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Alan Piszcz <ap@solarrain.com>
Subject: RE: Question regarding SAS controllers.
In-Reply-To: <660360F4F2570145BD872F298951B17A5CC4073E@cosmail03.lsi.com>
Message-ID: <alpine.DEB.1.10.0811221735240.14817@p34.internal.lan>
References: <660360F4F2570145BD872F298951B17A5CC4073E@cosmail03.lsi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Nov 2008, Moore, Eric wrote:

>> Firmware and BIOS for both Integrated RAID and Initiator-Target.  Must
>> boot to DOS to run utility.  Batch file simplifies installation.
>>
>> Welcome to LSI Logic Integrated SAS Flash Utility
>>       This Utility will upgrade your LSI SAS3442E HBA
>>
>
> Justin - We have linux tools for flashing firmware and bios.
>

Eric, one final question:
http://www.lsi.jp/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3041er/index.html
This obviously has 4 SAS/SATA ports (regular cables) and looks like it 
would be great in Linux/SW raid for SAS/SATA disks.

This (8 port version):
http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3081er/index.html
Has two SFF-8087 mini-SAS connectors.

It states "two (4) x1 SATA cables"

Does this mean:

8087 ------------> 8087 (with 4 lanes)

Thus it would require the purchase of an additional breakout cable or 
attachment to a special SATA/SAS enclosure.

or:

8087 ------------> regular sas/sata/1
                    regular sas/sata/2
                    regular sas/sata/3
                    regular sas/sata/4

Justin.
