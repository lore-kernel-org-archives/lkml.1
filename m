Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbXCTSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbXCTSLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965555AbXCTSLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:11:42 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:41531 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752674AbXCTSLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:11:41 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 14:11:40 EDT
Message-ID: <46002247.8020504@myrealbox.com>
Date: Tue, 20 Mar 2007 11:04:55 -0700
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 3.0a1 (Windows/20070315)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
CC: Eric St-Laurent <ericstl34@sympatico.ca>,
       Lee Revell <rlrevell@joe-job.com>, tglx@linutronix.de,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Len Brown <lenb@kernel.org>
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
   far
References: <200703161230.03712.maximlevitsky@gmail.com>	 <1174088686.13341.347.camel@localhost.localdomain>	 <75b66ecd0703192204n503eb4d3g361064f66319dd4c@mail.gmail.com>	 <1174368995.14239.3.camel@perkele> <1174382141.1158.61.camel@laptopd505.fenrus.org>
In-Reply-To: <1174382141.1158.61.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 2007-03-20 at 01:36 -0400, Eric St-Laurent wrote:
>> On Tue, 2007-20-03 at 01:04 -0400, Lee Revell wrote:
>>
>>> I think CONFIG_TRY_TO_DISABLE_SMI would be excellent for debugging,
>>> not to mention people trying to spec out hardware for RT
>>> applications...
>> There is a SMI disabling module in RTAI, check the smi-module.c in this:
>>
>> https://www.rtai.org/RTAI/rtai-3.5.tar.bz2
>>
>> More infos:
>>
>> http://www.captain.at/rtai-smi-high-latency.php
>> http://www.captain.at/xenomai-smi-high-latency.php
>>
>> It might make sense to merge this code, at least in the -rt tree.
> 
> it NEVER makes sense to disable SMM.
> 
> SMM is there to ensure that your hardware doesn't get physically
> damaged.
> 
> disabling that is a BAD idea. I'm no fan of SMM myself, but it's there,
> and we have to live with it. Disabling it without knowing what it does
> on your system is madness.
> 

How about disabling it long enough to calibrate the timers and then 
turning it back on?

--Andy

(apologies if anyone gets duplicates of this.  i'm encountering 
nightly-thunderbird-build bugs.)
