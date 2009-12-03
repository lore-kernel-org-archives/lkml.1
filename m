Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZLCBE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZLCBE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 20:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZLCBE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 20:04:58 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:58416 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZLCBE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 20:04:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TpUbRJaxfzmGDPIkZ+rgR1skzPF/Ns30fxTBrj27PGS92QsD9YsDygPDs8tf3nwopU
         l+TMKzS+ojML1Bgdz+8m1KkhU2XTkfjkqNZtnadhwMmO1gk+WhM5eDxigEn/RysntiX+
         A9EOvVaT0KkmRwueyJQbfT+VNX10m+hRFbw7k=
Message-ID: <4B170D46.9030701@gmail.com>
Date: Wed, 02 Dec 2009 16:58:46 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Linux-usb <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: root hub lost power or was reset
References: <dd18b0c30912021434t4a247646q48f32c0d0e40faae@mail.gmail.com> <4B1701EC.9030504@gmail.com>
In-Reply-To: <4B1701EC.9030504@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/09 16:10, Robert Hancock wrote:
> On 12/02/2009 04:34 PM, Justin Mattock wrote:
>> I've been getting a 45 sec
>> pause when waking my machine up
>> on the first cycle using s2ram.
>> At first thought it was udev, but later
>> am not sure it is. With further looking
>> if I remove the isight_firmware module from the kernel
>> suspend wakes up the first cycle as it should.(I don't have
>> isight-firmware-tools installed, leading me to believe this might
>> be the issue with isight-firmware.ko.)
>>
>> Now looking at dmesg I see:
>>
>> [ 413.551845] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low)
>> -> IRQ 23
>> [ 413.551855] uhci_hcd 0000:00:1d.0: setting latency timer to 64
>> [ 413.551887] usb usb2: root hub lost power or was reset
>
> Is that unexpected? It seems reasonable to me..
>

honestly I can't remember seeing this or not.
if this is normal then I'll leave it as is.

s2ram is working.. at first thought this was the cause,
but ended up not having anything todo with the real cause
of s2ram pausing.

Justin P. Mattock
