Return-Path: <linux-kernel-owner+w=401wt.eu-S1765485AbXFFSXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765485AbXFFSXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbXFFSXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:23:42 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3349 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099AbXFFSXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:23:41 -0400
Message-ID: <4666FBB8.3030600@shadowen.org>
Date: Wed, 06 Jun 2007 19:23:52 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org> <20070606163053.GM6909@holomorphy.com>
In-Reply-To: <20070606163053.GM6909@holomorphy.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Wed, Jun 06, 2007 at 02:07:37AM -0700, Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>> - Somebody broke it on my powerpc G5, but I didn't have time to do yet
>>   another bisection yet.
>> - There's a lengthy patch series here from Nick which attempts to address
>>   the longstanding pagefault-vs-buffered-write deadlock.
>>   A great shower of filesystems were broken and have been disabled with
>>   CONFIG_BROKEN.  This includes reiser4.
>> - Complex patches which eliminate the kernel's fixed size limit on the
>>   command-line length.  These break nommu builds.
> 
> Someone remind me what the pagefault vs. buffered write deadlock is.
> 
> Something brings down i386/qemu before even earlyprintk can handle.
> 
> Bisection has narrowed it down to patch 1140 after everything got
> renumbered by peterz' fix for mm-variable-length-argument-support.patch,
> namely containersv10-make-cpusets-a-client-of-containers.patch

Interestingly (and perhaps unrelatedly) on my _good_ boots the first
printk is no longer the kernel banner but the following which sounds
container related also:

Initializing container subsys cpuset

-apw
