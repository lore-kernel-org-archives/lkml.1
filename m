Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbXJ3T4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbXJ3T4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXJ3T4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:56:45 -0400
Received: from smtp4.netcabo.pt ([212.113.174.31]:48051 "EHLO
	exch01smtp09.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753146AbXJ3T4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:56:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAKYpJ0dViqaH/2dsb2JhbAAMkCY
Message-ID: <47278BE5.9070401@rncbc.org>
Date: Tue, 30 Oct 2007 19:54:13 +0000
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.23.1-rt5 (was 2.6.23-rt1 trouble)
References: <1192154640.15992.10.camel@localhost.localdomain>          <38542.213.58.131.130.1192445349.squirrel@www.rncbc.org> <471648B8.1030007@rncbc.org> <47234EA1.4050006@rncbc.org> <Pine.LNX.4.58.0710271203170.28617@gandalf.stny.rr.com> <47239A37.8000401@rncbc.org> <472781E3.7010103@rncbc.org> <Pine.LNX.4.58.0710301526480.30690@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0710301526480.30690@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2007 19:56:04.0402 (UTC) FILETIME=[E75B3920:01C81B2E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> --
> On Tue, 30 Oct 2007, Rui Nuno Capela wrote:
> 
>> still in trouble with 2.6.23.1-rt5 :(
>>
>> .config:
>>   http://www.rncbc.org/datahub/config-2.6.23.1-rt5.0
>>
>> serial console capture:
>>   http://www.rncbc.org/datahub/console-2.6.23.1-rt5.0-1.log
> 
> "NVRM: loading NVIDIA UNIX x86 Kernel Module  100.14.19  Wed Sep 12
>  14:12:24 PDT 2007"
> 
> Is that the nVidia module? Showing a date of Sept 12th also makes this
> look suspicious.
> 
> If this is the case, could you run without that module to see if we get
> the same freezes.
> 

yes, running without the *cough* nvidia module is under way. but do you
remember that on my other laptop the freezes also happen and on that one
there's no single proprietary modules in it? (same .config btw) problem
is, like most modern laptops, it doesn't come bundled with a serial port
so that can't give you a serial console evidence ...

thanks for the reminder, anyway ;)

> Thanks,
> 
> -- Steve
> 
>> one thing about SysRq-T: while in the middle of a freeze it just doesn't
>> dump anything, just the 'SysRq : Show State' line. you can see that
>> several times on the console output above.
>>
>> only when it is somewhat recovering, as said, by making some last resort
>> measures like SysRq-E as in 'SysRq: terminate All Tasks' for instance,
>> then SysRq-T will dump something. my guess is that this later dump will
>> be moot :/
>>
>> back to production with 2.6.22.1-rt9 ;)

bye now
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
