Return-Path: <linux-kernel-owner+w=401wt.eu-S933137AbZDJJt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbZDJJt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZDJJtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:49:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44324 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbZDJJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:49:39 -0400
Message-ID: <49DF1626.8080009@jp.fujitsu.com>
Date: Fri, 10 Apr 2009 18:49:26 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ying.huang@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
References: <20090407506.675031434@firstfloor.org> <20090407150656.43E161D046D@basil.firstfloor.org> <49DC5D11.4060505@jp.fujitsu.com> <87eiw3a29h.fsf@basil.nowhere.org> <49DD80B4.5060301@jp.fujitsu.com> <20090409071413.GD14687@one.firstfloor.org> <49DDC70E.2000602@jp.fujitsu.com> <20090409101349.GH14687@one.firstfloor.org> <49DECD2F.6060708@jp.fujitsu.com> <20090410082545.GP14687@one.firstfloor.org>
In-Reply-To: <20090410082545.GP14687@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, Apr 10, 2009 at 01:38:07PM +0900, Hidetoshi Seto wrote:
>> I still believe that using MSR which only available on 32bit from 64bit
> 
> The MSR is available on 64bit too (there are 64bit capable P4s
> like Prescott or Smithfield) 

The problem is the name which the MSR locating address 189H has.
Do you mind if I put this topic on the back-burner?

>> BTW, since this patch is "Improve", I think you need to clarify why you
>> bind it into the "bugfix" patch set for 2.6.30.  If there are known bug,
>> please describe about it.
> 
> It reports the incorrect RIP, fixing one of the test cases in the 
> MCE regression test suite.

Why is it incorrect?  In what case, what result is expected because why,
and how this patch fix it?


Thanks,
H.Seto

