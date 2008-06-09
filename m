Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbYFIU7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbYFIU7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbYFIU7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:59:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:53538 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbYFIU7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TVkh2hiKXqShZnPl7LKAPtpIZ4/osIuoYZVoU5VPxvMUBN6COljwBo97zKInF03Xvh
         9Ynl4LbZRnH+TiwDJzE9cyC8lyHvmpw8xo8HuyIu8WGGdIq5b0onYtKKIKJ9T0j0dhZ0
         ZGt/F6et0GyKdzZjjzU04kFj61ErTQHnIyNXY=
Message-ID: <4d8e3fd30806091359p1cda5e45o206160c76a7f5bc5@mail.gmail.com>
Date: Mon, 9 Jun 2008 22:59:28 +0200
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: coding style fixes to arch/x86/kernel/io_apic_32.c
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <20080609190204.GA13674@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080608130718.5d36e25b@paolo-desktop>
	 <20080609190204.GA13674@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 9:02 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
>> Before:
>> total: 91 errors, 73 warnings, 2850 lines checked
>>
>> After:
>> total: 1 errors, 47 warnings, 2848 lines checked
>
> applied, thanks. A small detail:

Thank you. Did you manage to look/apply the other two patches as well?
http://lkml.org/lkml/2008/6/7/64
http://lkml.org/lkml/2008/6/7/62

The latter might suffer for the same problem you fixed with the below patch.

>> +++ b/arch/x86/kernel/io_apic_32.c
>> @@ -37,12 +37,12 @@
>>  #include <linux/kthread.h>
>>  #include <linux/jiffies.h>   /* time_after() */
>>
>> -#include <asm/io.h>
>> -#include <asm/smp.h>
>> +#include <linux/io.h>
>> +#include <linux/smp.h>
>
> i suspect checkpatch suggested that asm/smp.h -> linux/smp.h change, but
> there was a subtle detail here - asm/smp.h has dual role on x86, it also
> carries a fair number of low level details about APIC/SMP details -
> which matters on UP IOAPIC.

You are right.
Sorry for not catching that.

BTW, I'm a bit lost in all the branches you are managing in the tip tree :-)
Which one should I look at to notice when the patches are applied?

Thanks.

Regards,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
