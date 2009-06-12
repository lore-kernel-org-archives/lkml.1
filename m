Return-Path: <linux-kernel-owner+w=401wt.eu-S1765721AbZFLR6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765721AbZFLR6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZFLR6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:58:31 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:32914 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZFLR6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:58:30 -0400
Message-ID: <4A329631.3030105@oracle.com>
Date: Fri, 12 Jun 2009 10:53:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counters: start documenting HAVE_PERF_COUNTERS requirements
References: <1244827063-24046-1-git-send-email-vapier@gentoo.org> <20090612173031.GA11233@elte.hu> <8bd0f97a0906121032p12710878h14c5013fbec58b91@mail.gmail.com> <20090612173647.GC22015@elte.hu> <8bd0f97a0906121040m5222cd5et77ecc1bd5edb6b89@mail.gmail.com> <4A329322.7030403@oracle.com> <20090612175624.GA18203@uranus.ravnborg.org>
In-Reply-To: <20090612175624.GA18203@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4A329706.03A9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, Jun 12, 2009 at 10:40:50AM -0700, Randy Dunlap wrote:
>> Mike Frysinger wrote:
>>> On Fri, Jun 12, 2009 at 13:36, Ingo Molnar wrote:
>>>> * Mike Frysinger <vapier.adi@gmail.com> wrote:
>>>>> On Fri, Jun 12, 2009 at 13:30, Ingo Molnar wrote:
>>>>>> * Mike Frysinger <vapier@gentoo.org> wrote:
>>>>>>> Help out arch porters who want to support perf counters by listing some
>>>>>>> basic requirements.
>>>>>>>
>>>>>>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>>>>>>> ---
>>>>>>> i imagine more details would be good, but this is a starting point and
>>>>>>> better than nothing
>>>>>>>
>>>>>>>  init/Kconfig          |    2 ++
>>>>>>>  tools/perf/design.txt |   15 +++++++++++++++
>>>>>>>  2 files changed, 17 insertions(+), 0 deletions(-)
>>>>>>>
>>>>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>>>>> index c649657..20f85b1 100644
>>>>>>> --- a/init/Kconfig
>>>>>>> +++ b/init/Kconfig
>>>>>>> @@ -936,6 +936,8 @@ config AIO
>>>>>>>
>>>>>>>  config HAVE_PERF_COUNTERS
>>>>>>>       bool
>>>>>>> +     help
>>>>>>> +       See end of tools/perf/design.txt
>>>>>>>
>>>>>>>  menu "Performance Counters"
>>>>>> Applied, thanks Mike! I have made a small change: i changed it from
>>>>>> help text into a regular comment. We usually use help texts for
>>>>>> interactive Kconfig options - but this is not one.
>>>>> yes, but i like the help text because when i use the kconfig
>>>>> search option, it shows up.  otherwise doing a search for
>>>>> HAVE_PERF_COUNTERS shows nothing useful.
>>>> When i did this modification i tried that in 'make menuconfig' and
>>>> the help didnt show up. Is it only available in certain kconfig
>>>> methods?
>> There is no prompt string for it, so it's invisible in menuconfig.
>> xconfig has View options that can show it.
>>
>>> hrm, you're right.  not sure what i was thinking of.  sounds like an
>>> enhancement request though for kconfig.
>> Could be.  Cc: Sam added.
> 
> We do not want to show the invisible symbols.

usually, yes.  But it can be very helpful to developers.
I use xconfig showing all symbols All Of The Time
(when not using menuconfig, that is).

> But the added help text is still fine as it is there when you
> grep the Kconfig file.


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
