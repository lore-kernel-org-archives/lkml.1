Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbXHLJ0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbXHLJ0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933814AbXHLJZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:25:46 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:42943 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933760AbXHLJZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:25:45 -0400
Message-ID: <46BED20C.308@linux.vnet.ibm.com>
Date: Sun, 12 Aug 2007 14:55:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
References: <386838491.27058@ustc.edu.cn> <661de9470708110730r1267bdfdp1e76546e11b64f78@mail.gmail.com> <20070811100015.2417788e.akpm@linux-foundation.org> <46BDF965.3050402@linux.vnet.ibm.com> <20070812054831.GB8992@mail.ustc.edu.cn> <386909088.16432@ustc.edu.cn>
In-Reply-To: <386909088.16432@ustc.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WU Fengguang wrote:
> On Sun, Aug 12, 2007 at 01:48:31PM +0800, WU Fengguang wrote:
>> On Sat, Aug 11, 2007 at 11:31:09PM +0530, Balbir Singh wrote:
>>> Andrew Morton wrote:
>>>> On Sat, 11 Aug 2007 20:00:12 +0530 "Balbir Singh" <balbir@linux.vnet.ibm.com> wrote:
>>>>> Shouldn't we just not stop vm accounting for kernel threads?
>>>>>
>>>> Could be.  It'd help heaps if we knew which patch in -mm caused
>>>> this, but from a quick peek it seems to me that mainline should be
>>>> vulnerable as well.
>>> Thats a valid point. It would be interesting to see what the overcommit
>>> setting was, when the panic occurred.
>> FYI, I do have nondefault overcommit settings:
>>
>> vm.overcommit_memory = 2
>> vm.lowmem_reserve_ratio = 1 1
> 
> Yes, the bug disappears when changing to default overcommit_memory!
> 

Great! So the problem might have existed for some time, but we never
saw it due to default over commit values? Were you using these values
for over commit even before?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
