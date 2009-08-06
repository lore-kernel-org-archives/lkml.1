Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZHFAWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZHFAWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZHFAWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:22:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53862 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZHFAWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:22:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A7A223C.1090705@jp.fujitsu.com>
Date: Thu, 06 Aug 2009 09:22:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       "H.Peter Anvin" <hpa@zytor.com>, LKLM <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH] x86, mce: cleanup initcall of debugfs for mce
References: <4A77CEAB.4030909@np.css.fujitsu.com> <4A77FCCC.7040608@linux.intel.com> <4A794A4E.2060802@np.css.fujitsu.com> <4A797F95.30906@linux.intel.com>
In-Reply-To: <4A797F95.30906@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jin Dongming wrote:
>> Andi Kleen wrote:
>>> Sorry but I think it's better to have an own initcall per file,
>>> that makes everything more self contained and easier to read.
>>>
>>> -Andi
>>>
>> Thank you for your comment.
>>
>> That's OK, but this patch is also used for resolving compile error
>> without CONFIG_DEBUG_FS.  Then how about this patch?
> 
> 
> Compiler errors should be always fixed of course. But did you check
> the compile error is still in the latest version of the x86/mce branch
> of
> git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
> It might be fixed already.

The compiler error pointed by Jin will be introduced by Huang's patch:
 3.x86: MCE: Move debugfs mce dir creating to mce.c
   URL: http://marc.info/?l=linux-kernel&m=124900459100790&w=2
and it seems that none of tip branches have Huang's debug patch set yet.
At least I could not find them in today's tip/x86/mce and tip/master.
(Or I might have trouble on syncing of git.)

I think that the previous change to unify initcalls is worth to be in
an incremental patch, but this trivial change to add ifdef could be
done by updating original patch if you'd like to do so.


Thanks,
H.Seto

