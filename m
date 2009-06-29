Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbZF2F6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbZF2F6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 01:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZF2F6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 01:58:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56052 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZF2F6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 01:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HPmoyR6OeTxphaW2XjEr7b7yuVz4sL8a9g7fEPo0dy6ypzse8MYg0qmQXcCrjrMiCV
         d7xttKMj2jttXsy3mKeydqHrnq18AHpWCXQ+ib5yAVwfMSEMPSFSouLpF+NmoQqFSn5T
         cJly5/RzOGWo6QxwtTThaiYmr5X4QQpOnhbLk=
MIME-Version: 1.0
In-Reply-To: <4A481B88.30806@gmail.com>
References: <87972c700906230516n538ad959nbd4b1ea21943ffc2@mail.gmail.com> 
	<1245761933.5987.20.camel@dax.rpnet.com> <4A481B88.30806@gmail.com>
From: Aviv Laufer <aviv.laufer@gmail.com>
Date: Mon, 29 Jun 2009 08:57:59 +0300
Message-ID: <87972c700906282257s368c7ddud4ecf06d50c882e2@mail.gmail.com>
Subject: Re: Bug in tdo24m
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, eric.miao@marvell.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I tested in on my PXA-270 board.
The patch was submitted and I guess it's waiting for approval
Aviv

On Mon, Jun 29, 2009 at 4:40 AM, Eric Miao<eric.y.miao@gmail.com> wrote:
> Richard Purdie wrote:
>> Hi,
>>
>> On Tue, 2009-06-23 at 15:16 +0300, Aviv Laufer wrote:
>>> I have found a bug in tdo24m.c .
>>> There is a call to kmalloc with the second param is sizeeof (flag)
>>> instead of flag.
>>> This cause  a crash.
>>
>> Thats quite a nasty bug and its surprising its not been found before
>> now! Can you resubmit the patch with description and most importantly a
>> Signed-off-by line please (see Documentation/SubmittingPatches)?
>>
>
> Ooops - this is embarrassing, yet I didn't find this causing any crash
> by now,  tdo24m works just OK on my Littleton and thus hiding this bug
> deeply.
>
> Aviv,
>
> Any update on this patch? I'd like to queue this ASAP.
>
