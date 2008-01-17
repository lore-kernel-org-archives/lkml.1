Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYAQUBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYAQUBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYAQUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:01:45 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:34761 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYAQUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:01:44 -0500
X-Auth-Info: uxp8r1X5X2ehf2i/6TPkkoayFvruL48lfdjVHJRo3iU=
X-Auth-Info: uxp8r1X5X2ehf2i/6TPkkoayFvruL48lfdjVHJRo3iU=
X-Auth-Info: uxp8r1X5X2ehf2i/6TPkkoayFvruL48lfdjVHJRo3iU=
X-Auth-Info: uxp8r1X5X2ehf2i/6TPkkoayFvruL48lfdjVHJRo3iU=
X-Auth-Info: uxp8r1X5X2ehf2i/6TPkkoayFvruL48lfdjVHJRo3iU=
X-Auth-Info: uxp8r1X5X2ehf2i/6TPkkoayFvruL48lfdjVHJRo3iU=
Message-ID: <478FB425.6050406@grandegger.com>
Date: Thu, 17 Jan 2008 21:01:41 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Daniel Walker <dwalker@mvista.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1
References: <1200544050.318.18.camel@localhost.localdomain>  <478F2A46.5070506@grandegger.com>  <1200586632.18731.141.camel@imap.mvista.com>  <478F9BCE.4030301@grandegger.com> <1200594655.18731.148.camel@imap.mvista.com> <Pine.LNX.4.58.0801171344290.28350@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0801171344290.28350@gandalf.stny.rr.com>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 17 Jan 2008, Daniel Walker wrote:
> 
>> On Thu, 2008-01-17 at 19:17 +0100, Wolfgang Grandegger wrote:
>>> [    0.733248] TCP bind hash table entries: 2048 (order: 3, 57344
>>> bytes)
>>> [    0.741132] TCP: Hash tables configured (established 2048 bind
>>> 2048)
>>> [    0.747981] TCP reno registered
>>> [    0.805896] krcupreemptd setsched 0
>>> [    0.809657]   prio = 98
>> That's interesting .. You chould try running cyclictest at priority 99
>> to eliminate other threads that might get involved (using -p99 instead
>> of -p80 , I think) ..
>>
> 
> But, anotherthing to try is disabling CONFIG_PREEMPT_RCU_BOOST, and see if
> that fixes anything.

It did not really help:

   /cyclictest -n -p99 -i1000
  3.89 3.46 1.77 1/43 3830

  T: 0 (  916) P:99 I:1000 C: 520752 Min:     52 Act:  112 Avg:  105
Max:     960

Any other idea?

Wolfgang.

