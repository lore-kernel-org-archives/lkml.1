Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYHHW0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYHHW0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbYHHW0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:26:15 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:5125 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbYHHW0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:26:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eak1VfwlmYZ5cbUQg9wqUg815Ib1rlL0a7fhYtzbTLWTdFHw1dluVZcF8KfFX3UysG
         pPrRT8Vfqbj7qong6YKN3Fq+4YOpt1qu4IpSSJN2ZLVZYr37GVHi6xZLmOF/dp8Jz/Oh
         efGbzZC5/+mB81JpT+OjZYB/p8kSI/Th8+e4U=
Message-ID: <86802c440808081526j3e04c845m99582c20b79196ca@mail.gmail.com>
Date: Fri, 8 Aug 2008 15:26:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/42] dyn_array/nr_irqs/sparse_irq support v5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <489CC684.8060607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	 <489CC684.8060607@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 3:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> based on tip/master
>>
>> to do:
>>   so dyn irq_desc is done, and ready to:
>>   make create_irq to get irq according to bus/dev/func/vector
>>
>
> Hm... I tried to check this in as a separate topic branch, but it conflicts
> against both linus and against tip:x86/core, which are the branches we
> usually base topic branches on.

Ingo said, I only need to work on tip/master, and you guys will sort it out.
Eric's NR_IRQS patch for 2.6.27 is not in tip yet. --- Andrew picked up already

maybe i need put eric's patch before alan's patch in next sending...

>
> I really am not convinced about the whole dyn_array concept, and
> *especially* not having divergences between 32 and 64 bits with regards to
> sparse IRQs.  Furthermore, there are a number of checkpatch errors for this
> patch series, most of which appear legit.

will check it. it could be just replace irq_desc[] to irq_desc()...

>
> So again... any reason to not just have sparse IRQs and be done with it?

another reason: dyn_arry == static in some case, so I could make sure
compiling work well between static/dyn_array with sparse_irq.

YH
