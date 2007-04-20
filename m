Return-Path: <linux-kernel-owner+w=401wt.eu-S1030977AbXDTTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030977AbXDTTcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030980AbXDTTcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:32:19 -0400
Received: from mail.tmr.com ([64.65.253.246]:43733 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030977AbXDTTcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:32:18 -0400
Message-ID: <4629152C.7020801@tmr.com>
Date: Fri, 20 Apr 2007 15:31:56 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Ingo Molnar <mingo@elte.hu>,
       Christoph Pfister <christophpfister@gmail.com>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <200704181625.51389.caglar@pardus.org.tr> <20070418154811.GA16842@elte.hu> <200704190008.19262.caglar@pardus.org.tr>
In-Reply-To: <200704190008.19262.caglar@pardus.org.tr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çag(lar Onur wrote:
> 18 Nis 2007 Çar tarihinde, Ingo Molnar s,unlar? yazm?s,t?: 
>> * S.Çag(lar Onur <caglar@pardus.org.tr> wrote:
>>> -       schedule();
>>> +       msleep(1);
>>>
>>> which Ingo sends me to try also has the same effect on me. I cannot
>>> reproduce hangs anymore with that patch applied top of CFS while one
>>> console checks out SVN repos and other one compiles a small test
>>> software.
>> great! Could you please unapply the hack above and try the proper fix
>> below, does this one solve the hangs too?
> 
> Instead of that one, i tried CFSv3 and i cannot reproduce the hang anymore, 
> Thanks!...
> 
And that explains why CFS-v3 on 21-rc7-git3 wouldn't show me the hang. 
As a matter of fact, nothing I did showed any bad behavior! Note that I 
was doing actual badly behaved things which do sometimes glitch the 
standard scheduler, not running benchmarks.

This scheduler is boring, everything works. I am going to try some tests 
on a uniprocessor, though, I have been running everything on either SMP 
or HT CPUs. But so far it looks fine.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

