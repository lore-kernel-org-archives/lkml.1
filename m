Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYIVPNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYIVPNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYIVPM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:12:59 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54588 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752605AbYIVPM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:12:58 -0400
Message-ID: <48D7B5F8.9020300@sgi.com>
Date: Mon, 22 Sep 2008 08:12:56 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Dean Nelson <dcn@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, jeremy@goop.org, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH 1/3] switch vector_irq[] from irq number to irq_desc	pointer
 v2
References: <20080919200212.GA6528@sgi.com> <20080919200449.GB6528@sgi.com> <48D40A97.2000402@sgi.com> <20080922110542.GD5987@elte.hu>
In-Reply-To: <20080922110542.GD5987@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Hi Ingo,
>>
>> Note that my recent patch from a couple of weeks ago, stripped almost 
>> all of the cpumask_t's from the io_apic functions.  Any chance we can 
>> apply them before we add more?
>>
>> I'd be willing to merge in Dean's patch over the top of mine (or 
>> vice-versa).
> 
> i'm really looking forwards to Rusty's 'get-rid-of-cpumask_t use' 
> patchset, which would solve such cpumask_t proliferation issues once and 
> for all.
> 
> 	Ingo

Hi Ingo,

The net effect of the "getting rid of cpumask_t's" will be the same.  This
patch reduces considerably the amount of stack space being required right
now.  The new cpumask_t approach will take quite a bit of time to get it
"up and running".  (It took me about a day to get init/main.c and kernel/sched.c
to just compile... it now needs the temp cpumasks to actually function.  And
there are a number of areas that will need to be altered before functional
testing can start.)

Thanks,
Mike
