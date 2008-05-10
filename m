Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYEJQoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYEJQoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 12:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYEJQoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 12:44:03 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:45085 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbYEJQoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 12:44:00 -0400
Message-ID: <4825D0CC.8040501@linux.vnet.ibm.com>
Date: Sat, 10 May 2008 22:13:56 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: kernel list <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.25-rc2-git4 - Regression Kernel oops  while running
 kernbench and tbench on powerpc
References: <47BC40BC.3040405@linux.vnet.ibm.com> <18427.11023.8067.795279@cargo.ozlabs.ibm.com> <47FB5C5A.5020104@linux.vnet.ibm.com> <18427.65299.403151.344959@cargo.ozlabs.ibm.com> <47FC5227.3030501@linux.vnet.ibm.com> <18435.11286.201115.396713@cargo.ozlabs.ibm.com> <48035C03.10104@linux.vnet.ibm.com> <18446.61538.620549.715043@cargo.ozlabs.ibm.com> <4810231B.6020105@linux.vnet.ibm.com> <18467.49613.367933.672004@cargo.ozlabs.ibm.com>
In-Reply-To: <18467.49613.367933.672004@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Kamalesh Babulal writes:
> 
>> Thanks, after applying the patch the oops is not reproducible on the machine. The console
>> log had no message starting with SLB: or FWNMI:. I have updated the bugzilla also.
>>
>> Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> 
> Could you test Linus' current git tree and see if you can reproduce
> the same problem now?  The patch I sent upstream was a little
> different from the one you tested, though it should have the same
> effect, and I would like to be sure that it is just as effective at
> fixing the bug.
> 
> Thanks,
> Paul.

Hi Paul,

The patch has the same effect. I tested the 2.6.26-rc1-git7 kernel and
the oops is not reproducible.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
