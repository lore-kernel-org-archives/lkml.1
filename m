Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZCCKEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZCCKEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 05:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZCCKEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 05:04:38 -0500
Received: from wa4ehsobe001.messaging.microsoft.com ([216.32.181.11]:10421
	"EHLO WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752296AbZCCKEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 05:04:37 -0500
X-BigFish: VPS-42(zz1432R62a3L98dR936eQ4015M1805Mzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KFXDB2-03-76P-01
Date: Tue, 3 Mar 2009 11:04:12 +0100
From: Robert Richter <robert.richter@amd.com>
To: Tim Blechmann <tim@klingt.org>, Ingo Molnar <mingo@elte.hu>
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] oprofile: don't set counter width from cpuid on core2
Message-ID: <20090303100412.GC10085@erda.amd.com>
References: <20090216114010.GG25042@erda.amd.com> <20090219173403.49871cac@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090219173403.49871cac@thinkpad>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Mar 2009 10:04:12.0989 (UTC) FILETIME=[67511ED0:01C99BE7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.02.09 17:34:03, Tim Blechmann wrote:
> resetting the counter width of the performance counters on intel's
> core2, breaks the delivery of NMIs, when running in x86_64 mode.
> 
> this should fix bug #12395:
> http://bugzilla.kernel.org/show_bug.cgi?id=12395

Applied to oprofile/fixes. Thanks Tim.

Ingo, please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git fixes

for v2.6.29-rc7.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

