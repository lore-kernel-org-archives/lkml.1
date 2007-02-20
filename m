Return-Path: <linux-kernel-owner+w=401wt.eu-S1161086AbXBTXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161086AbXBTXYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161082AbXBTXYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:24:25 -0500
Received: from mail.tmr.com ([64.65.253.246]:48522 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161081AbXBTXYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:24:04 -0500
Message-ID: <45DB82BC.60805@tmr.com>
Date: Tue, 20 Feb 2007 18:22:36 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 000 of 6] md: Assorted fixes and features for md for 2.6.21
References: <20070220172544.15678.patches@notabene>
In-Reply-To: <20070220172544.15678.patches@notabene>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown wrote:
> Following 6 patches are against 2.6.20 and are suitable for 2.6.21.
> They are not against -mm because the new plugging makes raid5 not work
> and so not testable, and there are a few fairly minor intersections between
> these patches and those patches.
> There is also a very minor conflict with the hardware-xor patches - one line
> of context is different.
>
> Patch 1 should probably go in -stable - the bug could cause data
> corruption in a fairly uncommon raid10 configuration, so that one and
> this intro are Cc:ed to stable@kernel.org.
>
> Thanks,
> NeilBrown
>
>
>  [PATCH 001 of 6] md: Fix raid10 recovery problem.
>  [PATCH 002 of 6] md: RAID6: clean up CPUID and FPU enter/exit code
>  [PATCH 003 of 6] md: Move warning about creating a raid array on partitions of the one device.
>  [PATCH 004 of 6] md: Clean out unplug and other queue function on md shutdown
>  [PATCH 005 of 6] md: Restart a (raid5) reshape that has been aborted due to a read/write error.
>  [PATCH 006 of 6] md: Add support for reshape of a raid6

Every month or so there are a bunch of patches like this, which do 
various enhancements to the kernel. And these are usually based against 
the release kernel, and all is fine. But every once in a while there is 
a patch which is more urgent, in this case the RAID10 one, which is 
really desirable to get into every kernel running on a machine. Are 
patches marked as needed for -stable also fast tracked to -git inclusion?

If this isn't in -git14 I'm going to rebuild with it before testing 
Neil's NFS stuff. The NFS server test data is on RAID10 ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

