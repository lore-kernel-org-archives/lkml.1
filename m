Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZAKRA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZAKRA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZAKQ7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:59:50 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:38265 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZAKQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dje5K/xaTGkC61aobWfq2MY1B9HqHU+V5cNwMmwtcWhtocdcqIBUPYXVPgDJQtWFvg
         qanlT2u8OR26jqvHKY0XXS/N/9JFdW5/0gQCAhW07ZxGgKGWN1FJWlRhDHPM1wYdpcCS
         8ZhhMy+FdSB22jEiUZBF4k/iauK5vpNkbcw/8=
Message-ID: <496A2580.2080103@gmail.com>
Date: Sun, 11 Jan 2009 12:59:44 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: venkatesh.pallipadi@intel.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/6] PAT fixes/cleanup following the pfnmap changes
References: <20090110001308.403550000@intel.com> <49689C80.3070905@gmail.com> <20090111020508.GA29153@elte.hu>
In-Reply-To: <20090111020508.GA29153@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
>> venkatesh.pallipadi@intel.com wrote:
>>> Individual patch header has descriptions.
>>>
>> $ git am Patches
>> Applying: x86 PAT: change track_pfn_vma_new to take pgprot_t pointer param
>> error: patch failed: mm/memory.c:1604
>> error: mm/memory.c: patch does not apply
>> Patch failed at 0001.
>> When you have resolved this problem run "git am --resolved".
>> If you would prefer to skip this patch, instead run "git am --skip".
>> To restore the original branch and stop patching run "git am --abort".
>>
>> These do not apply for me to latest Linus git, which is the tree where I 
>> experienced the problem.  Is there some way to fuzz them to get them to 
>> apply?
> 
> Could you check tip/master:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> do you still get the messages? [ Btw., did you also experience any 3D 
> performance problems that are solved via Venki's fixes in tip/master? ]
> 

I just checked tip/master, and I do still get the messages:

[   66.895807] X:5022 map pfn expected mapping type write-back for d0000000-d0101000, got write-combining
[   66.895873] X:5022 freeing invalid memtype d0000000-d0101000

As for 3D performance issues, glxgears without any other applications running gives:

    457 frames in 5.0 seconds = 91.312 FPS
    475 frames in 5.0 seconds = 94.887 FPS
    478 frames in 5.0 seconds = 95.411 FPS

I can't say for sure, but I expect those numbers should be much higher for a 3D accelerated radeon card (even if it is a little old):

    01:00.0 VGA compatible controller: ATI Technologies Inc M9+ 5C61 [Radeon Mobility 9200 (AGP)] (rev 01)

glxinfo gives:

    direct rendering: Yes


Anything else I can try?

-- 
Kevin Winchester
