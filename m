Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYLVJST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYLVJST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 04:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYLVJSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 04:18:04 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:37262 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYLVJSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 04:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G98x6Jdm0VDFBFaBNqiX3NBWIIqBvx3rULtWfdiz4wWXHbhIhGFMxyvnMAno0xXMcs
         XnrioszXfLS9XMMeuA5qyYSwiLw8mEq83DzAcbgfAKqIz3u562FvveVt4Lr/7iacybYe
         eev0hqn5wBRqs/puxef+ihedaVnvhSOyeEOOI=
Message-ID: <f4527be0812220117v6fcc72c6v8012247ec443f636@mail.gmail.com>
Date: Mon, 22 Dec 2008 09:17:58 +0000
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: Help interpreting AHCI failure messages
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Robert Hancock" <hancockr@shaw.ca>, "Jeff Garzik" <jeff@garzik.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>
In-Reply-To: <494F11FD.1040606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4942D651.1050306@goop.org> <4943317C.8000807@shaw.ca>
	 <49434EC9.4070408@goop.org> <49446DD0.3030600@gmail.com>
	 <494BCC08.4070206@goop.org> <494F11FD.1040606@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 4:05 AM, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> Jeremy Fitzhardinge wrote:
>>>> Furthermore, ata2 - which is sharing the same interrupt - seems to have
>>>> managed to read the DVD drive's information, so something must be
>>>> working.  But why is it failing for the disk?
>>>
>>> Can you try irqpoll on it?
>>
>> Here's a log of a run where everything works initially, but then it
>> starts to fail (about half way into the log).  ATA_DEBUG is enabled, so
>> its pretty verbose.
>>
>> http://kraxel.fedorapeople.org/for-jeremy/xeni.log
>>
>> Does anything stand out?
>
> Can you please exclude pata_acpi from the initrd and see whether
> anything changes?

I have already tried using a kernel with pata_acpi disabled, it does not help.

Andy

>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
