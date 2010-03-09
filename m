Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0CIPJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:09:34 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50390 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab0CIPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:09:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=HbyhDQ1xzvXjfEw6Aq1rqo32NaV/yHrQ0c7nNGdjXpApEG7958u/XHGIM6aYfkDe6G
         1Dfopeat4PbUJQk0zYJCc5E8fEfTxJldJKr9NUhPllAJn3wMnN+Jzt1pcH1F1v5ceKT0
         4rYoBS0F8Et5L90JrdwADe27MgKLw+v5gxHho=
References: <aa4c40ff1003081107n78e9f052n2a754680e5491c68@mail.gmail.com> <aa4c40ff1003081313s7492513bk14a48c6097b90407@mail.gmail.com> <4B95B028.3050106@gmail.com> <aa4c40ff1003082115x3e9e1492je90e5afb826b3408@mail.gmail.com> <20100309141552.GD30538@centrinvest.ru>
Message-Id: <8DFD46FA-A938-41D6-97EC-F6E5324C9FAA@gmail.com>
From: James Lamanna <jlamanna@gmail.com>
To: Andrey Panin <pazke@centrinvest.ru>
In-Reply-To: <20100309141552.GD30538@centrinvest.ru>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: SIIG DP CyberSerial 4S PCIe Support
Date: Tue, 9 Mar 2010 07:09:21 -0800
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 9, 2010, at 6:15, "Andrey Panin" <pazke@centrinvest.ru> wrote:

> On 067, 03 08, 2010 at 09:15:26PM -0800, James Lamanna wrote:
>
>> That's probably the case.
>> It looks like 8250 doesn't know about this PCIe device at all.
>> The Oxford PCI ID is not in pci_ids.h nor is the SIIG subsystem ID.
>> I'll see if I can maybe work up a patch to support this device,  
>> since I've found
>> the datasheet for the Oxford 4 port UART controller, but I may need  
>> some help.
>> Or if anyone else (who has more experience with this) wants to  
>> formulate one,
>> it would be greatly appreciated.
>
> Looks like you card can use existing code for Oxford Semiconductor  
> UARTs.
> Can you test the attached patch for 2.6.33 ?

Hi Andrey,
Coincidentally I found your patch for 2.6.28 that I was able to  
backport to 2.6.24. The card seems to be working great!
Is this patch in mainline now?

Thanks.

-- James
