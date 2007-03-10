Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbXCJLny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbXCJLny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 06:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXCJLnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 06:43:53 -0500
Received: from mail29.syd.optusnet.com.au ([211.29.132.171]:40152 "EHLO
	mail29.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbXCJLnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 06:43:53 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RSDL-mm 0/6]  Rotating Staircase DeadLine scheduler for -mm
Date: Sat, 10 Mar 2007 22:51:42 +1100
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200703101825.13015.kernel@kolivas.org>
In-Reply-To: <200703101825.13015.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703102251.43211.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 18:25, Con Kolivas wrote:
> What follows this email is a series of patches for the RSDL cpu scheduler
> as found in 2.6.21-rc3-mm1. This series is for 2.6.21-rc3-mm2 and has some
> bugfixes for the issues found so far. While it is not clear that I've
> attended to all the bugs, it is worth noting that a complete rewrite is a
> teensy bit more than a trivial change shall we say ;)
>
> akpm it still has trouble on that monster config of yours but there's so
> much else going on in this -mm I don't know what to make of it. getting ppc
> to work on qemu was more work than I thought and I haven't succeeded there
> yet either :|
>
> A rolled up patch can be found here:
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl.patch
>
> Patch series here:
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2/
>
> and the patch series will follow. If time permits I will make available a
> newer version for the older kernels soon.
>
> Changelog:
> - Made it possible for the idle task to schedule on cpu_hotplug.
> - Fixed the accounting across fork()
> - Recalculation of priority for tasks that have already run this major
> rotation and are now on the expired array was wrong. It has been corrected.
> - The bitmap error that has been hit on some architectures was made more
> verbose to make it clear that something has gone wrong, and will keep going
> off if the problem persists.

Oh and if it wasn't clear from this message. It still needs work to be bug 
free and probably shouldn't be part of -mm till I've ironed out all the 
oopsen. Thanks.

-- 
-ck
