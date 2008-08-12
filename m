Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYHLIIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYHLIIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 04:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYHLIH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 04:07:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:27152 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYHLIH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 04:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z/Bf2ww3G8kPm21MAI6gtDXjQCKHYH+0j1esPpSNqw/FfR292BXuIaagRAKBcDoA9N
         xTayRloupnLQVg7xLwCKNVBU63GAW0OPUmLtSSNLelZlONyO6jouvKXvihhRnTCij0RD
         Sjm4Ex+y0DLe2fYEpk27FrSZu/H86lCyHJOI0=
Message-ID: <8db1092f0808120107k1f8a65f4sf406fa3a89125870@mail.gmail.com>
Date: Tue, 12 Aug 2008 10:07:54 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <20080812081632.303de380@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
	 <20080811202731.GB2916@elte.hu>
	 <86802c440808112352j2175d2edlf421c44499f8c1c0@mail.gmail.com>
	 <20080812081632.303de380@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/12 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> > +sr 4:0:0:0: Attached scsi CD-ROM sr0
>>
>> looks like you are using ata driver for pata device instead of ide driver.
>>
>> so could be caused by bug in ata_piix...
>
> See the original bug report - he tried both and got the same kind of
> behaviour.
>
>

Yes I have similar behaviour, very often kernel stops on this message:
http://unixy.pl/maciek/download/kernel/dupa/2.6.26.2_config_ide/img_0001.jpg

I added CONFIG_IDE, difference between pervious config and current:
http://unixy.pl/maciek/download/kernel/dupa/2.6.26.2_config_ide/config.diff

Full .config:
http://unixy.pl/maciek/download/kernel/dupa/2.6.26.2_config_ide/config-2.6.26.2

Dmesg (1 time works ok):
http://unixy.pl/maciek/download/kernel/dupa/2.6.26.2_config_ide/dmesg.txt

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
