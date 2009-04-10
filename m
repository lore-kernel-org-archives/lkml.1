Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZDJEib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZDJEib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 00:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZDJEiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 00:38:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50437 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZDJEiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 00:38:20 -0400
Message-ID: <49DECD2F.6060708@jp.fujitsu.com>
Date: Fri, 10 Apr 2009 13:38:07 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ying.huang@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
References: <20090407506.675031434@firstfloor.org> <20090407150656.43E161D046D@basil.firstfloor.org> <49DC5D11.4060505@jp.fujitsu.com> <87eiw3a29h.fsf@basil.nowhere.org> <49DD80B4.5060301@jp.fujitsu.com> <20090409071413.GD14687@one.firstfloor.org> <49DDC70E.2000602@jp.fujitsu.com> <20090409101349.GH14687@one.firstfloor.org>
In-Reply-To: <20090409101349.GH14687@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Following is a proposal version. Maybe dividing it into 2 pieces, function
>> improvement and MSR definition, would be a good idea.
> 
> I don't think we need the full MSR definitions right now, at least 
> I don't have any plans to support them. After all current CPUs
> don't.
> 
> The rest looks good.

Thanks.

I still believe that using MSR which only available on 32bit from 64bit
code is not right thing.  However this is not logical bug, and adding
definition is not suitable for 2.6.30.  I'd like to defer the MSR part
to the next time.

BTW, since this patch is "Improve", I think you need to clarify why you
bind it into the "bugfix" patch set for 2.6.30.  If there are known bug,
please describe about it.


Thanks,
H.Seto

