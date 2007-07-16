Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbXGPX07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbXGPX07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbXGPX0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:26:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:63275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbXGPX0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:26:51 -0400
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
From: utz lehmann <lkml123@s2y4n2c.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Bodo Eggert <7eggert@gmx.de>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <469BF104.1040703@gmail.com>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8FYWD-2eS-7@gated-at.bofh.it>
	 <8GdsH-8dc-13@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
	 <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>
	 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
	 <E1  <469BF104.1040703@gmail.com>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 01:26:35 +0200
Message-Id: <1184628395.8707.15.camel@segv.aura.of.mankind>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18ij6MuAxvLUWbIK/YTrrUzkGAC4JngBYc464r
 IjWzUH1tI/oVHVBqum1vf8G/Dx5T/YjkFq2bFX/ouflhazJAlo
 GGicjyJZb5U8sHjPfkcQrZs6ZRHC5WM
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 00:28 +0200, Rene Herman wrote:
> Given that as Arjan stated Fedora and even RHEL have been using 4K stacks 
> for some time now, and certainly the latter being a distribution which I 
> would expect to both host a relatively large number of lvm/md/xfs and what 
> stackeaters have you users and to be fairly conservative with respect to the 
> chances of scribbling over kernel memory (I'm a trusting person...) it seems 
>   there might at this stage only be very few offenders left.

I have to recompile the fedora kernel rpms (fc6, f7) with 8k stacks on
my i686 server. It's using NFS -> XFS -> DM -> MD (raid1) -> IDE disks.
With 4k stacks it crash (hang) within minutes after using NFS.
With 8k stacks it's rock solid. No crashes within months.

utz


