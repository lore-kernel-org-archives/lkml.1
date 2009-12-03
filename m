Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZLCLhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZLCLhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZLCLhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:37:45 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62392 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZLCLho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:37:44 -0500
Message-ID: <4B17A2F8.9080408@petalogix.com>
Date: Thu, 03 Dec 2009 12:37:28 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 3
References: <20091203180214.16e452ed.sfr@canb.auug.org.au> <4B176B50.4050901@petalogix.com> <4B17771B.7050902@kernel.org>
In-Reply-To: <4B17771B.7050902@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> On 12/03/2009 04:40 PM, Michal Simek wrote:
>> todays tree is working on MMU microblaze correctly without any visible
>> problem but noMMU microblaze kernel still have that bug as I reported
>> some days ago.
> 
> Other than triggering WARN_ON(), it doesn't cause any other problems,
> right?  It's probably because SMP_CACHE_BYTES on that configuration is
> lower than 8.  What is the value of SMP_CACHE_BYTES on the
> configuration?  Also, doesn't the Linus's tree have the same problem?

aaa - I was too fast and compiled noMMU tree for 09-12-02 not todays.
You can check it at http://www.monstr.eu/wiki/doku.php?id=log:log

The problem seems to me is away.

Thanks,
Michal


> 
> The somewhat spurious WARN_ON() in percpu allocator should probably be
> just removed or bumped to check against PAGE_SIZE as SMP code does.
> The problem is that on UP even though the function takes @align
> parameter, it just ignores it.  :-(
> 
> Thanks.
> 


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
