Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbYGQJrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbYGQJrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYGQJrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:47:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:36093 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbYGQJre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=INGUoAUO+VMp2mPjBdwnEbpuYetSadCsj337Y2faMwazBMDbn2BFXIDh92UlbwC90R
         w8D0V1rnxiDiMgDYPO83FyzEj9m7O+Zd9wuDEbUTmx6RwnUHkO9VAKhUacuTV0i7Esdf
         frVusqsrLq/PUxTrIyVGAq/pOMa/a1UwGUrqQ=
Message-ID: <87a5b0800807170247g48a01c65n1cfa365b52dbc12c@mail.gmail.com>
Date: Thu, 17 Jul 2008 10:47:33 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Li Yang" <LeoLi@freescale.com>
Subject: Re: [PATCH 00/11] fsl_usb2_udc: A number of bug fixes and cleanups.
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Jiang Bo" <tanya.jiang@freescale.com>, gregkh@suse.de
In-Reply-To: <989B956029373F45A0B8AF0297081890027C4EC2@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
	 <989B956029373F45A0B8AF0297081890027C4EC2@zch01exm26.fsl.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 10:43 AM, Li Yang <LeoLi@freescale.com> wrote:
>> -----Original Message-----
>> From: Will Newton [mailto:will.newton@imgtec.com]
>> Sent: Tuesday, July 15, 2008 11:25 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: linux-usb@vger.kernel.org; Li Yang; Jiang Bo;
>> gregkh@suse.de; Will Newton
>> Subject: [PATCH 00/11] fsl_usb2_udc: A number of bug fixes
>> and cleanups.
>>
>> From: Will Newton <will.newton@gmail.com>
>>
>> Hi,
>>
>> These patches fix a couple of small bugs and cleanup parts of
>> the fsl_usb2_udc USB gadget driver. I've split them up quite
>> finely for ease of reviewing and to separate functional
>> changes. Any comments would be appreciated.
>>
>> I would also appreciate it if someone with real Freescale
>> hardware could test these changes, I'm testing this driver
>> with a different SoC containing the same TDI/ARC/ChipIdea IP block.
>
> Thanks for the patches.  Looks like they are ok, but I still need to
> test them later.
>
> What's the SoC you have tested with the driver?  Maybe you could also
> update the Kconfig for that.

It's actually one of these:

http://www.frontier-silicon.com/products/chips/chorus2.htm

Support for which is not yet in the mainline kernel. Kconfig updates
should follow when the SoC support is merged but I hope these patches
all make sense for any chip using this IP.

> - Leo
>>
>> Thanks,
>>
>> Will Newton (11):
>>   fsl_usb2_udc: Make dr_ep_setup function static.
>>   fsl_usb2_udc: Remove check for udc == NULL in dr_controller_setup.
>>   fsl_usb2_udc: Fix some sparse warnings and remove redundant code.
>>   fsl_usb2_udc: Clean up whitespace in errors and warnings.
>>   fsl_usb2_udc: Clean up whitespace in /proc debugging output.
>>   fsl_usb2_udc: Initialize spinlock earlier.
>>   fsl_usb2_udc: Rename the arguments of the fsl_writel macro.
>>   fsl_usb2_udc: Uninline udc_reset_ep_queue.
>>   fsl_usb2_udc: Make fsl_queue_td return type void.
>>   fsl_usb2_udc: Add a wmb before priming endpoint.
>>   fsl_usb2_udc: Fix oops on probe failure.
>>
>>  drivers/usb/gadget/fsl_usb2_udc.c |  176
>> ++++++++++++++++--------------------
>>  drivers/usb/gadget/fsl_usb2_udc.h |   21 +----
>>  2 files changed, 80 insertions(+), 117 deletions(-)
>>
>> -
>> This message is subject to Imagination Technologies' e-mail
>> terms: http://www.imgtec.com/e-mail.htm
>> -
>>
>>
>
