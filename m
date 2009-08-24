Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbZHXBfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbZHXBfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZHXBfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:35:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZHXBfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:35:30 -0400
Message-ID: <4A91EEAA.4070200@redhat.com>
Date: Mon, 24 Aug 2009 09:36:42 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, nhorman@redhat.com, ebiederm@xmission.com,
       andi@firstfloor.org, mingo@elte.hu, bernhard.walle@gmx.de,
       fenghua.yu@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
       avorontsov@ru.mvista.com
Subject: Re: [Patch 1/8] kexec: allow to shrink reserved memory
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>	<20090821065650.4855.53279.sendpatchset@localhost.localdomain> <20090821171738.304fe91e.akpm@linux-foundation.org>
In-Reply-To: <20090821171738.304fe91e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 21 Aug 2009 02:54:25 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
>
>   
>> +size_t get_crash_memory_size(void)
>> +int shrink_crash_memory(unsigned long new_size)
>>     
>
> These aren't particualrly well-chosen global identifiers.  It would be
> better if they were called crash_*() or kexec_*(), to make it clear
> which subsystem they belong to.
>
>   

Ah, good poi nt!

How about crash_get_memory_size() and crash_shrink_memory()?

Thanks!



