Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYIRQV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYIRQV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYIRQVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:21:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbYIRQVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:21:20 -0400
Date: Thu, 18 Sep 2008 12:19:57 -0400
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
Message-ID: <20080918161957.GC3097@redhat.com>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <20080917015543.27172da4.akpm@linux-foundation.org> <20080917092732.GB32107@elte.hu> <20080917184618.GB6486@redhat.com> <48D159A7.5080907@zytor.com> <20080918105728.GF20967@elte.hu> <48D2758B.1000004@zytor.com> <20080918155041.GB3097@redhat.com> <48D27A7E.8090403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D27A7E.8090403@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 08:57:50AM -0700, H. Peter Anvin wrote:
> Jason Baron wrote:
>>
>> if we take this argument to its extreme, then we end up spending all of
>> our time verifying that the kernel is working correctly and no time
>> actually doing work. I think 'printk_ratelimit' captures this. Thus, 
>> the line has to be drawn somewhere. If you want the messages in 'dmesg' 
>> use,
>> printk(KERN_DEBUG), and 'grep'. For the rest, I propose pre-filtering, which is
>> what 'dynamic debug' uses.
>>
>
> Taking any argument to its extreme and you come up with something  
> ridiculous.
>
> One could equally argue that if you have so many debugging messages that  
> you have to prefilter for performance, you're so bloating your kernel  
> that you need to stop.

in my testing there was no significant difference between pre-filtering
vs. not built in. However, there was a measureable affect of having them
built in vs. not built in.

>
> I find it highly questionable that it makes sense to put even skipped  
> messages into hot paths in the production kernel.  Skipped prints are  
> NOT free, even if they are lot cheaper than actually rendering the 
> string.
>

If you feel that way, you simply don't have to turn the single CONFIG_ on.
Futher, the patchset allows fine-grained control over the modules that
you would want to enable/disable.

thanks,

-Jason

