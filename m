Return-Path: <linux-kernel-owner+w=401wt.eu-S932120AbZACPbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbZACPbx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 10:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZACPbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 10:31:40 -0500
Received: from relay2.sgi.com ([192.48.179.30]:51267 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758530AbZACPbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 10:31:39 -0500
Message-ID: <495F84D8.1070404@sgi.com>
Date: Sat, 03 Jan 2009 07:31:36 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <495F7D27.8020104@sgi.com> <20090103150634.GA28693@elte.hu>
In-Reply-To: <20090103150634.GA28693@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>> Once we have figured out the CPU-hotplug lockdep splat (possibly due 
>>> to Mike's changes not yours) i'll send it to Linus. Thanks,
>>>
>>> 	Ingo
>> Thanks!  Am working on that now.
> 
> do you suspect any of the commits? I'm bisecting it right now but if you 
> have bisected it already i wont repeat it.
> 
> 	Ingo

I haven't done that yet, I'm just now getting your config to work pre-patches.

But yes, I suspect one of the changes to use "work_on_cpu" -- this usually
causes the 2nd call to get_online_cpus().

Thanks,
Mike
