Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYHOIeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYHOIeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYHOIeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:34:23 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:50816 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYHOIeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u7Kdf+iGDSDmIGOEvfy19+306Ewb3KvtyjzXXKb1LqfxLmbKpj9EKA5utyhXabuU+X
         D4ne+CcjVBpj+/S9jMjmZH1P+rAsQ+t1EmyfzOR3Wig+/SlLdIMquQDw4SYVXhUA63Y1
         y/+S21iDfYW3LjN6ssRjMVxne+QHxWoP8zpco=
Message-ID: <86802c440808150134x5bf005fmdcb0f557422af365@mail.gmail.com>
Date: Fri, 15 Aug 2008 01:34:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 00/07] dyn_array/nr_irqs/sparse_irq support v10 - fix
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080815082735.GC4776@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080815082735.GC4776@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 1:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>>       fix the 32bit with bigsmp
>>       fix 64 bit with irq migration
>>       ordering functions in io_apic_xx.c
>>
>>
>> to do:
>>     merge io_apic_xx.c
>
> applied to tip/irq/sparseirq - thanks Yinghai, great work!
>
> What do you think about Eric's abstraction suggestion, that irq_desc's
> structure should be hidden from all but kernel/irq/* code. I think
> that's a sane suggestion. We do it in mm/slab.c too: no external code
> knows the structure of 'struct kmem_cache'.

current arch code use irq_desc directly..., if need to irq_desc to
them, need to provide set_irq(..., ...)

YH
