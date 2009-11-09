Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbZKIWbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbZKIWbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZKIWbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:31:02 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:31484 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbZKIWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:31:01 -0500
Message-ID: <4AF89779.9090601@oracle.com>
Date: Mon, 09 Nov 2009 14:28:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Naohiro Ooiwa <nooiwa@miraclelinux.com>, Ingo Molnar <mingo@elte.hu>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
Subject: Re: [PATCH] kernel.h: Add printk_ratelimited and pr_<level>_rl
References: <4AEACFBF.4060108@miraclelinux.com>	 <20091030143333.414ea29c.akpm@linux-foundation.org>	 <1256939158.1917.43.camel@Joe-Laptop.home>	 <1256944907.1917.109.camel@Joe-Laptop.home>	 <20091109134914.70de28cf.akpm@linux-foundation.org> <1257804320.12852.16.camel@Joe-Laptop.home>
In-Reply-To: <1257804320.12852.16.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AF897C4.0059:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Mon, 2009-11-09 at 13:49 -0800, Andrew Morton wrote:
>> On Fri, 30 Oct 2009 16:21:47 -0700
>> Joe Perches <joe@perches.com> wrote:
>>> +#define pr_emerg_rl(fmt, ...) \
>>> +        printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
>>> +#define pr_alert_rl(fmt, ...) \
>>> +        printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
>>> +#define pr_crit_rl(fmt, ...) \
>>> +        printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
>>> +#define pr_err_rl(fmt, ...) \
>>> +        printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>>> +#define pr_warning_rl(fmt, ...) \
>>> +        printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
>>> +#define pr_notice_rl(fmt, ...) \
>>> +        printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
>>> +#define pr_info_rl(fmt, ...) \
>>> +        printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>> Would prefer pr_emerg_ratelimited personally.  It's longer, but one
>> doesn't ask "wtf does _rl" mean and it avoids having two identifiers
>> which refer to the same thing.
> 
> I don't have a strong opinion either way.
> _rl is shorter and that has some value.

but we have a long history of not using cryptic abbreviations,
so I agree with Andrew.

> I think pr_crit_rl, pr_emerg_rl and pr_alert_rl likely
> aren't useful.  Is there a sensible use case for those?

Not likely.

> I added them for completeness, but...

