Return-Path: <linux-kernel-owner+w=401wt.eu-S1761117AbYBSUz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117AbYBSUz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYBSUzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:55:51 -0500
Received: from senator.holtmann.net ([87.106.208.187]:42816 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbYBSUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:55:49 -0500
Cc: linux-kernel@vger.kernel.org
Message-Id: <AC57C59C-2B98-44F5-A408-05BBC11C08B9@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: SDiZ <sdiz@sdiz.net>
In-Reply-To: <47B315CA.4080600@sdiz.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH][BLUETOOTH] add HCI_BROKEN_ISOC for 0e5e:6622 (bugzilla #9027)
Date: Tue, 19 Feb 2008 21:55:45 +0100
References: <47B266AE.3040908@sdiz.net> <1202898692.7664.369.camel@violet>	 <47B30E11.2080903@sdiz.net> <1202917206.7664.417.camel@violet> <47B315CA.4080600@sdiz.net>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>>>>> This patch fix bugzilla #9027.
>>>>> ``Syslog flooded with "hci_scodata_packet: hci0 SCO packet for  
>>>>> unknown
>>>>> connection handle 92" message"
>>>>>
>>>>> see http://bugzilla.kernel.org/show_bug.cgi?id=9027
>>>>>
>>>>>
>>>> when we get the content of /proc/bus/usb/devices for this one. Do  
>>>> you
>>>> have the manufacturer name of it or at least an idea which kind of
>>>> device this is. Check "hciconfig hci0 version".
>>>>
>>>>
>>> It have no text on the chips and package, so I don't know the
>>> manufacturer name.
>>>
>>
>> and what about "hciconfig hci0 version"?
>>
> hci0: Type: USB
> BD Address: 11:11:11:11:11:11 ACL MTU: 672:3 SCO MTU: 48:1
> HCI Ver: 2.0 (0x3) HCI Rev: 0x1f4 LMP Ver: 2.0 (0x3) LMP Subver: 0x1f4
> Manufacturer: CONWISE Technology Corporation Ltd (66)

this is really a broken device. Please update your comment in your  
patch and re-sent it. The comment should read

/* CONWISE Technology based adapters with buggy SCO support */

And also put the entry right after the RTX Telecom one.

Regards

Marcel

