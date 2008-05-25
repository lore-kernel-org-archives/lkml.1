Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYEYTEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYEYTEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757523AbYEYTEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:04:01 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59162 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbYEYTEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:04:00 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
Message-Id: <A0703DD1-0E98-4B7E-81C0-67332B6873BA@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200805252053.36854.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 21:03:56 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805252039.17673.mb@bu3sch.de> <BF546351-0C53-41C4-977A-6A777AF4D602@holtmann.org> <200805252053.36854.mb@bu3sch.de>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

>> Again, I don't plan to break any setup. I actually do think it is a
>> good idea to group firmware files in subdirectories in /lib/firmware,
>> but this subdirectory name doesn't belong in the kernel.
>>
>> We will update udev to read the driver name and look into /lib/
>> firmware/<driver>/<filename> and /lib/firmware/<filename> for the
>> firmware file.
>>
>> Then we will set a date and note it in the future remove document.
>> Something like 12 month after an updated udev has been released. This
>> gives the distribution two generations time to update udev and kernel
>> packages.
>
> How are you going to handle multiple versions of the firmware for  
> one driver?
> How does one switch between versions (changing config files is not  
> acceptable)?

that is your point of view. Why is changing a config file not  
acceptable?

Regards

Marcel

