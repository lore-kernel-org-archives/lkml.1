Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZGOPDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZGOPDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbZGOPD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:03:29 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:46606 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZGOPD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:03:28 -0400
X-Greylist: delayed 37577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 11:03:28 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LnH76wApbQLJZtqTeAHaq49wZH+uOUmdmNYpsW3sOqYtKD3gn1ReNPzoAI3OGv4wIv
         bNvVW73opTv+QmspryD39zJoxMxnQ2jyVAxCIZK+vOCP2kXKaiK2KnAAtAZRw9qetptY
         vTzVhjUSxpYqZ2Q35IufkYzU/4SoRu8UtqURo=
MIME-Version: 1.0
In-Reply-To: <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
	 <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
Date: Wed, 15 Jul 2009 20:33:27 +0530
Message-ID: <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com>
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
From: rohan a <info1686@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Any suggestions...please help


On Wed, Jul 15, 2009 at 11:56 AM, rohan a<info1686@gmail.com> wrote:
> I do not want to move to the SG3 driver as of now since all devices
> are working on all Linux platforms using the deprectaed SG driver.
>
>
>
> On 7/15/09, rohan a <info1686@gmail.com> wrote:
>> Hello,
>>        The SCSI command for LTO-4 drive based encryption (SPOUT
>> opcode = 0xB5) is failing on SLES 9 32-bit only and not on SLES 9 (64-
>> bit), SLES 10,11 or RHEL 4/5
>>
>> Any idea why this is happening?
>>
>> Error returned is : Invalid field in CDB
>>
>> I am using ioctl() with the deprecated request SCSI_IOCTL_SEND_COMMAND
>> and not the SG3 driver.
>> However, only the SPOUT command is failing and none of the other SCSI
>> commands.
>> For ex: even the SPIN command (to obtain encryption status and
>> capabilities) works.
>>
>> I even updated to SP4.
>>
>> Any suggestions here?
>>
>> Thanks
>>
>
