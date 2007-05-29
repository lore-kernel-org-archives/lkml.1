Return-Path: <linux-kernel-owner+w=401wt.eu-S1763144AbXE2Dal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763144AbXE2Dal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 23:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbXE2Dae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 23:30:34 -0400
Received: from omta04sl.mx.bigpond.com ([144.140.93.156]:23028 "EHLO
	omta04sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXE2Dad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 23:30:33 -0400
Message-ID: <465B9E50.9060805@bigpond.net.au>
Date: Tue, 29 May 2007 13:30:24 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: Kirill Korotaev <dev@sw.ru>, Nick Piggin <nickpiggin@yahoo.com.au>,
       tingy@cs.umass.edu, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, wli@holomorphy.com, tong.n.li@intel.com,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
References: <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070528172658.GA18582@in.ibm.com> <465B7163.7020403@bigpond.net.au>
In-Reply-To: <465B7163.7020403@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta04sl.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Tue, 29 May 2007 03:30:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Srivatsa Vaddagiri wrote:
>> On Sat, May 26, 2007 at 10:17:42AM +1000, Peter Williams wrote:
>>> I don't think that ignoring cpu affinity is an option.  Setting the 
>>> cpu affinity of tasks is a deliberate policy action on the part of 
>>> the system administrator and has to be honoured.  
>>
>> mmm ..but users can set cpu affinity w/o administrator priveleges ..
>>
> 
> OK. So you have to assume the users know what they're doing. :-)
> 
> In reality though, the policy of allowing ordinary users to set affinity 
> on their tasks should be rethought.

After more contemplation, I now think I may have gone overboard here.  I 
am now of the opinion that any degradation of overall system performance 
due to the use of cpu affinity would be confined to the tasks with cpu 
affinity set.  So there's no need to prevent ordinary users from setting 
cpu affinity on their own processes as any degradation will only affect 
them.

So it goes back to the situation where you have to assume that they know 
what they're doing and obey their policy.

> 
> In any case, there's no point having cpu affinity if it's going to be 
> ignored.  Maybe you could have two levels of affinity: 1. if set by a 
> root it must be obeyed; and 2. if set by an ordinary user it can be 
> overridden if the best interests of the system dictate.  BUT I think 
> that would be a bad idea.

This idea is now not just bad but unnecessary.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
