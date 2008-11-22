Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbYKVWn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbYKVWn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYKVWnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:43:47 -0500
Received: from lucidpixels.com ([75.144.35.66]:35441 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYKVWnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:43:46 -0500
Date: Sat, 22 Nov 2008 17:43:45 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Moore, Eric" <Eric.Moore@lsi.com>
cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Alan Piszcz <ap@solarrain.com>
Subject: RE: Question regarding SAS controllers.
In-Reply-To: <alpine.DEB.1.10.0811221735240.14817@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0811221741500.14817@p34.internal.lan>
References: <660360F4F2570145BD872F298951B17A5CC4073E@cosmail03.lsi.com> <alpine.DEB.1.10.0811221735240.14817@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Nov 2008, Justin Piszcz wrote:

>
>
> On Sat, 22 Nov 2008, Moore, Eric wrote:
>
>>> Firmware and BIOS for both Integrated RAID and Initiator-Target.  Must
>>> boot to DOS to run utility.  Batch file simplifies installation.
>>> 
>>> Welcome to LSI Logic Integrated SAS Flash Utility
>>>       This Utility will upgrade your LSI SAS3442E HBA
>>> 
>> 
>> Justin - We have linux tools for flashing firmware and bios.
>> 
>
> Eric, one final question:
> http://www.lsi.jp/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3041er/index.html
> This obviously has 4 SAS/SATA ports (regular cables) and looks like it would 
> be great in Linux/SW raid for SAS/SATA disks.
>
> This (8 port version):
> http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3081er/index.html
> Has two SFF-8087 mini-SAS connectors.
>
> It states "two (4) x1 SATA cables"
>
> Does this mean:
>
> 8087 ------------> 8087 (with 4 lanes)
>
> Thus it would require the purchase of an additional breakout cable or 
> attachment to a special SATA/SAS enclosure.
>
> or:
>
> 8087 ------------> regular sas/sata/1
>                   regular sas/sata/2
>                   regular sas/sata/3
>                   regular sas/sata/4
>
> Justin.
>

Newegg has the answer:
http://www.newegg.com/Product/Product.aspx?Item=N82E16816118092
http://c1.neweggimages.com/NeweggImage/productimage/16-118-092-07.jpg

Follow-up:
http://www.newegg.com/Product/Product.aspx?Item=N82E16816118058
http://www.newegg.com/Product/Product.aspx?Item=N82E16816118092

How come the reviews are so bad for these cards?  (They mostly used the HW 
raid function, which I am not interested in).

Eric,

If one runs:

dd if=/dev/disk1 of=/dev/null bs=1M &

For eight disk drives on the 8-port SAS controller in an x8 or x16 slot, 
will they be able to achieve the maximum bandwidth of each drive, for 
example, velociraptor = 800MiB/s so it should 800MiB/s in aggregate reads 
(using direct-bare mode), NOT on-board raid?

Justin.
