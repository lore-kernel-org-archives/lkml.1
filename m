Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZCMBny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZCMBny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbZCMBnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:43:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59317 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZCMBnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:43:45 -0400
Message-ID: <49B9BA51.70105@cn.fujitsu.com>
Date: Fri, 13 Mar 2009 09:43:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       balbir@in.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] cpuset: Check if the cpus allowed is a	subset
 of the cpuset's cpus for PF_THREAD_BOUND threads
References: <20090312174501.GA7821@linux.vnet.ibm.com> <tip-5a98d36112f4301f068b638d6e0db2357f7deb75@git.kernel.org> <20090313013241.GA6107@elte.hu>
In-Reply-To: <20090313013241.GA6107@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: David Rientjes <rientjes@google.com>

Ingo Molnar wrote:
> * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
>> Commit-ID:  5a98d36112f4301f068b638d6e0db2357f7deb75
>> Gitweb:     http://git.kernel.org/tip/5a98d36112f4301f068b638d6e0db2357f7deb75
>> Author:     Dhaval Giani <dhaval@linux.vnet.ibm.com>
>> AuthorDate: Thu, 12 Mar 2009 23:15:01 +0530
>> Commit:     Ingo Molnar <mingo@elte.hu>
>> CommitDate: Fri, 13 Mar 2009 00:21:25 +0100
>>
>> cpuset: Check if the cpus allowed is a subset of the cpuset's 
>> cpus for PF_THREAD_BOUND threads
> 
> Dropped this patch for now - Andrew says it got NAK-ed and he's 
> handling it with other fixes.
> 

It's not a bug, it's David Rientjes that introduced this behavior:
	9985b0bab332289f14837eff3c6e0bcc658b58f7

And here was the discussion:
	http://lkml.org/lkml/2008/6/5/310
