Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYHHKOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYHHKOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYHHKNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:13:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:12938 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYHHKNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bC3DQfPWWnpTCE6xo9NOZ56pErnnKzicMWdnv/1AM2PLvrMcNgEFUNLmwJpfd69mI9
         O7uXXDtKP6jB7v1n4Wvocyg0jVnzE6SaWoh09pyp2vphJMDzcPLMsEmB8JjK5iNsBnGh
         7SvBB3O88dbFFh8OKiNXx7pOQ3rU/T+6ePwf0=
Message-ID: <87a5b0800808080313p1e20f956m5776bfde1e139c69@mail.gmail.com>
Date: Fri, 8 Aug 2008 11:13:53 +0100
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

Hi Leo,

Have you had a chance to test these patches yet?

Thanks,

> What's the SoC you have tested with the driver?  Maybe you could also
> update the Kconfig for that.
>
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
