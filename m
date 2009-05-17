Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZEQB1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZEQB1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 21:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZEQB1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 21:27:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:12006 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZEQB1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 21:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UANRE7fR31OBB5i8BhVVugwjkbmWxaYwa0q4WmDX8In0WiH0U5Jte3txfXIWgBuXd8
         bUcPXZj3EfPqCiKr5ugazMkjAvxvHyUefyF6MoefNOoFx6YZacRRtdkvy3D8eVvcTd/0
         3so/tWRPJMTpS0kG6+fTwRpmy9N/OhqWnX0rw=
MIME-Version: 1.0
In-Reply-To: <20090517011906.GA6375@localhost>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
	 <alpine.DEB.1.10.0905151533070.13433@qirst.com>
	 <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com>
	 <4A0EFA08.4060106@redhat.com> <20090517011906.GA6375@localhost>
Date: Sun, 17 May 2009 06:57:03 +0530
Message-ID: <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, better to apply Rik and mine patches together to get the best
> cache behavior. Rik's patch is crucial. They are both small patches,
> so can be backported trivially. Satish, what's your kernel version
> (or, do you want to try a newer kernel)? And the content of
> /proc/meminfo?

I am running 2.6.29.1 right now , just tell me which kernel to try, or
to which kernel I have to apply the patches and try them, I will test
the patches and let you know if the situation improves.
and the contents of /proc/meminfo are :
MemTotal:        2585724 kB
MemFree:          900524 kB
Buffers:          197504 kB
Cached:          1080332 kB
SwapCached:            0 kB
Active:           639544 kB
Inactive:         933068 kB
Active(anon):     307100 kB
Inactive(anon):        0 kB
Active(file):     332444 kB
Inactive(file):   933068 kB
Unevictable:          16 kB
Mlocked:              16 kB
HighTotal:       1707848 kB
HighFree:         321868 kB
LowTotal:         877876 kB
LowFree:          578656 kB
SwapTotal:       3526256 kB
SwapFree:        3526256 kB
Dirty:              1000 kB
Writeback:             0 kB
AnonPages:        294788 kB
Mapped:            80084 kB
Slab:              89692 kB
SReclaimable:      71436 kB
SUnreclaim:        18256 kB
PageTables:         6008 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4819116 kB
Committed_AS:     796332 kB
VmallocTotal:     122880 kB
VmallocUsed:        8240 kB
VmallocChunk:      96952 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       20472 kB
DirectMap4M:      884736 kB

Cheers
Satish
-- 
http://satish.playdrupal.com
