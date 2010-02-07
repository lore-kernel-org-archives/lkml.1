Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab0BGM4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 07:56:12 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:33501 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab0BGM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 07:56:09 -0500
Message-ID: <4B6EB844.4090001@xenontk.org>
Date: Sun, 07 Feb 2010 18:25:32 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       ykzhao <yakui.zhao@intel.com>
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.NbF.2FiZLB@chimera> <4B669F8F.1030402@xenontk.org> <201002022155.44016.rjw@sisk.pl>
In-Reply-To: <201002022155.44016.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 02:25 AM, Rafael J. Wysocki wrote:
> On Monday 01 February 2010, David John wrote:
>> On 02/01/2010 06:13 AM, Rafael J. Wysocki wrote:
>>> This message has been generated automatically as a part of a report
>>> of regressions introduced between 2.6.31 and 2.6.32.
>>>
>>> The following bug entry is on the current list of known regressions
>>> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>>> be listed and let me know (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14897
>>> Subject		: i915: Commit 0e442c60 causes flickering
>>> Submitter	: David John <davidjon@xenontk.org>
>>> Date		: 2009-12-09 17:26 (54 days old)
>>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
>>> References	: http://marc.info/?l=linux-kernel&m=126037889600769&w=4
>>> Handled-By	: David John <davidjon@xenontk.org>
>>> Patch		: http://patchwork.kernel.org/patch/75423/
>>>
>>>
>>>
>>
>> Hi Rafael,
>>
>> The patch fixing this has not been merged yet, so the bug should still
>> be listed.
> 
> Thanks for the update, I'll close the bug when I see the patch in the Linus'
> tree.
> 
> Rafael
> 

Hi Rafael,

This regression entry can now be closed, it's fixed by the upstream
commit 33c5fd12 (drm/i915: Disable SR when more than one pipe is enabled).

Thanks,
David.
