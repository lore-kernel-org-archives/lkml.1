Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYLVEFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYLVEFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 23:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYLVEFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 23:05:31 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:41786 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYLVEFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 23:05:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=D9oKBP/Q7XDb8lUOGsJMEBfPOgAZYwVmF6jJKo0HB/ddk4DvBivK8QIT3fv33r+yz7
         XJjAvfbkVyk3DYGsiX/DZ5/29JADbmsEJN7MCvbeGTqdtCaZaUBtQ/BkpPYnn/a6QuzB
         WKAzIi/nbDSazpq+aqTUmA0/rmh4YpF9+aaZY=
Message-ID: <494F11FD.1040606@gmail.com>
Date: Mon, 22 Dec 2008 13:05:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: Help interpreting AHCI failure messages
References: <4942D651.1050306@goop.org> <4943317C.8000807@shaw.ca> <49434EC9.4070408@goop.org> <49446DD0.3030600@gmail.com> <494BCC08.4070206@goop.org>
In-Reply-To: <494BCC08.4070206@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeremy Fitzhardinge wrote:
>>> Furthermore, ata2 - which is sharing the same interrupt - seems to have
>>> managed to read the DVD drive's information, so something must be
>>> working.  But why is it failing for the disk?
>>
>> Can you try irqpoll on it?
> 
> Here's a log of a run where everything works initially, but then it
> starts to fail (about half way into the log).  ATA_DEBUG is enabled, so
> its pretty verbose.
> 
> http://kraxel.fedorapeople.org/for-jeremy/xeni.log
> 
> Does anything stand out?

Can you please exclude pata_acpi from the initrd and see whether
anything changes?

-- 
tejun
