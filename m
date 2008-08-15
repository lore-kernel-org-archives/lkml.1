Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYHOIaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYHOIaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYHOI34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:29:56 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:51422 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbYHOI3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O03aGiHgfQLz4h8HofODCFSRWGIy2+28hwqmcdl4GDfAeROTnk4b4IV0Wr56ArdqWN
         RtrPnaUTL7pw+oFoK13QvG+qbJ+0bL6pTF5raJdwlOD7ecYzIiiGvz97LazuRWeed3jv
         XWRJ9B9qfar37r8lonfImc0PB2vUi2dGwp29Y=
Message-ID: <86802c440808150129v6474bf66mc329c46129c24e3c@mail.gmail.com>
Date: Fri, 15 Aug 2008 01:29:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/7] x86: make 32bit support per_cpu vector fix #1
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080815082147.GB4776@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
	 <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com>
	 <1218766832-20476-3-git-send-email-yhlu.kernel@gmail.com>
	 <1218766832-20476-4-git-send-email-yhlu.kernel@gmail.com>
	 <20080815082147.GB4776@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 1:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> +#ifdef CONFIG_SMP
>> +        return cpu_online_map;
>> +#else
>> +        return cpumask_of_cpu(0);
>> +#endif
>
> unrelated sidenote - shouldnt the scheduler define cpu_online_map to
> cpumask_of_cpu(0) on UP, to avoid such ugly #ifdefs?

copy that from mach_default...

should double check if cpu_online_map is cpu_mask_of_cpu(0) if !CONFIG_SMP

YH
