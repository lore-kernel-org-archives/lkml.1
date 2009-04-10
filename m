Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbZDJIXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbZDJIXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbZDJIXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:23:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60704 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZDJIXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:23:23 -0400
Date: Fri, 10 Apr 2009 10:25:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
Message-ID: <20090410082545.GP14687@one.firstfloor.org>
References: <20090407506.675031434@firstfloor.org> <20090407150656.43E161D046D@basil.firstfloor.org> <49DC5D11.4060505@jp.fujitsu.com> <87eiw3a29h.fsf@basil.nowhere.org> <49DD80B4.5060301@jp.fujitsu.com> <20090409071413.GD14687@one.firstfloor.org> <49DDC70E.2000602@jp.fujitsu.com> <20090409101349.GH14687@one.firstfloor.org> <49DECD2F.6060708@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DECD2F.6060708@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 01:38:07PM +0900, Hidetoshi Seto wrote:
> Andi Kleen wrote:
> >> Following is a proposal version. Maybe dividing it into 2 pieces, function
> >> improvement and MSR definition, would be a good idea.
> > 
> > I don't think we need the full MSR definitions right now, at least 
> > I don't have any plans to support them. After all current CPUs
> > don't.
> > 
> > The rest looks good.
> 
> Thanks.
> 
> I still believe that using MSR which only available on 32bit from 64bit

The MSR is available on 64bit too (there are 64bit capable P4s
like Prescott or Smithfield) 

> code is not right thing.  However this is not logical bug, and adding
> definition is not suitable for 2.6.30.  I'd like to defer the MSR part
> to the next time.
> 
> BTW, since this patch is "Improve", I think you need to clarify why you
> bind it into the "bugfix" patch set for 2.6.30.  If there are known bug,
> please describe about it.

It reports the incorrect RIP, fixing one of the test cases in the 
MCE regression test suite.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
