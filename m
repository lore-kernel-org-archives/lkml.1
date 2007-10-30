Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXJ3TNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXJ3TNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbXJ3TN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:13:28 -0400
Received: from smtp1.netcabo.pt ([212.113.174.28]:14374 "EHLO
	exch01smtp10.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752771AbXJ3TN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:13:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAABsfJ0dViqaH/2dsb2JhbAAMkCY
Message-ID: <472781E3.7010103@rncbc.org>
Date: Tue, 30 Oct 2007 19:11:31 +0000
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.23.1-rt5 (was 2.6.23-rt1 trouble)
References: <1192154640.15992.10.camel@localhost.localdomain>          <38542.213.58.131.130.1192445349.squirrel@www.rncbc.org> <471648B8.1030007@rncbc.org> <47234EA1.4050006@rncbc.org> <Pine.LNX.4.58.0710271203170.28617@gandalf.stny.rr.com> <47239A37.8000401@rncbc.org>
In-Reply-To: <47239A37.8000401@rncbc.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2007 19:13:21.0756 (UTC) FILETIME=[EFE679C0:01C81B28]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rui Nuno Capela wrote:
> Steven Rostedt wrote:
>>
>> When things start to freeze, could you capture the output of a sysrq-t.
>>
> 
> yes, you can find a complete serial console capture here, where it holds
> the final SysRq-T output:
>   http://www.rncbc.org/datahub/console-2.6.23.1-rt4.1-1.log
> 
> the corresponding .config is also there:
>   http://www.rncbc.org/datahub/config-2.6.23.1-rt4.1
> 
> the reason this is a new kernel build, following a shot in the dark from
> nick mainsbridge, which let out the ntfs module build (CONFIG_NTFS_FS is
> not set) suggesting that would mitigate similar freezes.
> 
> in deed the general feel is that it seems to run longer and less prone
> to those incidents, but that is just a gut feeling, nothing more.
> 
> hope this be any useful.
> 
>> I have a P4HT laptop (unfortunately with no serial). I use it as one of my
>> main machines, so it will suck for me when it freezes ;-). I'll take your
>> config and try it out.
>>
>> I'll most likely do this on Monday since process Wife has the highest
>> priority over the weekend ;-)
>>
> 
> that is also true here :)
> 
> otoh, as reported before, the freezes are not exclusive to P4HT, which
> is the main box I'm been reporting here (the one which has a good old
> serial port anyway), but also applies to my other laptop, an core2 duo
> t7200.
> 

still in trouble with 2.6.23.1-rt5 :(

.config:
  http://www.rncbc.org/datahub/config-2.6.23.1-rt5.0

serial console capture:
  http://www.rncbc.org/datahub/console-2.6.23.1-rt5.0-1.log

one thing about SysRq-T: while in the middle of a freeze it just doesn't
dump anything, just the 'SysRq : Show State' line. you can see that
several times on the console output above.

only when it is somewhat recovering, as said, by making some last resort
measures like SysRq-E as in 'SysRq: terminate All Tasks' for instance,
then SysRq-T will dump something. my guess is that this later dump will
be moot :/

back to production with 2.6.22.1-rt9 ;)
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
