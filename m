Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZGGE0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZGGE0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 00:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZGGE0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 00:26:33 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:62654 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZGGE0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 00:26:32 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [Bug #13665] commit 69c854817566 causes OOMs
Date: Tue, 07 Jul 2009 00:25:50 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.30.1; KDE/4.2.4; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "Wu Fengguang" <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
 <dWkuWjWDsSB.A.U7E.g0oUKB@chimera>
 <20090707130450.cb14f7b9.minchan.kim@barrios-desktop>
In-reply-to: <20090707130450.cb14f7b9.minchan.kim@barrios-desktop>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907070025.51256.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Minchan Kim wrote:
>On Tue,  7 Jul 2009 02:01:03 +0200 (CEST)
>
>"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.30.  Please verify if it still should be listed and let me know
>> (either way).
>
>It should be listed.
>
>I think it is caused by forking process bomb by msgctl11 on LTP.
>We can refer old
> discussion(http://osdir.com/ml/linux-kernel/2009-07/msg00926.html)
>
>I think this issue can be solved by
>dynamic reclaim throttling patch which is making by Rik.
>
>After he merges it, Let's test again.
>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13665
>> Subject		: commit 69c854817566 causes OOMs
>> Submitter	: David Howells <dhowells@redhat.com>
>> Date		: 2009-06-27 08:12 (10 days old)
>> First-Bad-Commit:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;
>>h=69c854817566db82c362797b4a6521d0b00fe1d8 References	:
>> http://lkml.org/lkml/2009/6/27/28
>> Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
>> Patch		: http://patchwork.kernel.org/patch/32740/

If I can chime in here, I just had to reboot from 2.6.31-rc2 for the 2nd time 
in about 24 hours cuz the oom killer killed it.  Back on 2.6.30.1 ATM for 
effects.

I have a previous post with traces etc.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

The truth is rarely pure, and never simple.
		-- Oscar Wilde

