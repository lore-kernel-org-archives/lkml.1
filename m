Return-Path: <linux-kernel-owner+w=401wt.eu-S965187AbXCUWRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187AbXCUWRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965194AbXCUWRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:17:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:44359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965187AbXCUWRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:17:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,310,1170662400"; 
   d="scan'208"; a="61991121:sNHT19724112"
In-Reply-To: <20070321220456.GA3796@redhat.com>
References: <20070321202339.GB29367@linux-os.sc.intel.com> <20070321220456.GA3796@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8F4448F7-640A-4741-8121-875A104DCA7F@intel.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Content-Transfer-Encoding: 7bit
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 2/2] Export deferrable timer through workqueue and use it in ondemand governor
Date: Wed, 21 Mar 2007 15:19:45 -0700
To: Dave Jones <davej@redhat.com>
X-Mailer: Apple Mail (2.752.3)
X-OriginalArrivalTime: 21 Mar 2007 22:17:48.0296 (UTC) FILETIME=[C1F43880:01C76C06]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mar 21, 2007, at 3:04 PM, Dave Jones wrote:

> On Wed, Mar 21, 2007 at 01:23:40PM -0700, Venkatesh Pallipadi wrote:
>>
>>
>> Add a new deferrable delayed work init. This can be used to  
>> schedule work
>> that are 'unimportant' when CPU is idle and can be called later,  
>> when CPU
>> eventually comes out of idle.
>>
>> Use this init in cpufreq ondemand governor.
>>
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
> drivers/cpufreq/cpufreq_ondemand.c: In function 'dbs_timer_init':
> drivers/cpufreq/cpufreq_ondemand.c:473: error: implicit declaration  
> of function 'init_timer_deferrable'
>
>


init_timer_deferrable is defined in
[PATCH 1/2] Add support for deferrable timers
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/2064.html

Do you get this error after that patch?

Thanks,
~Venki
