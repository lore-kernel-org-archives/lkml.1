Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbXGQOq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbXGQOq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbXGQOqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:46:50 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:38733 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbXGQOqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:46:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18076.54789.359986.788880@stoffel.org>
Date: Tue, 17 Jul 2007 10:45:25 -0400
From: "John Stoffel" <john@stoffel.org>
To: utz lehmann <lkml123@s2y4n2c.de>
Cc: Rene Herman <rene.herman@gmail.com>, Bodo Eggert <7eggert@gmx.de>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <1184628395.8707.15.camel@segv.aura.of.mankind>
References: <8FO1e-2jW-35@gated-at.bofh.it>
	<8FYWD-2eS-7@gated-at.bofh.it>
	<8GdsH-8dc-13@gated-at.bofh.it>
	<8Ghmx-60z-17@gated-at.bofh.it>
	<8Gj55-hJ-5@gated-at.bofh.it>
	<8GkNo-2Vb-1@gated-at.bofh.it>
	<8GtnN-7TG-23@gated-at.bofh.it>
	<8GVjY-PL-25@gated-at.bofh.it>
	<E1  <469BF104.1040703@gmail.com>
	<1184628395.8707.15.camel@segv.aura.of.mankind>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


utz> On Tue, 2007-07-17 at 00:28 +0200, Rene Herman wrote:
>> Given that as Arjan stated Fedora and even RHEL have been using 4K stacks 
>> for some time now, and certainly the latter being a distribution which I 
>> would expect to both host a relatively large number of lvm/md/xfs and what 
>> stackeaters have you users and to be fairly conservative with respect to the 
>> chances of scribbling over kernel memory (I'm a trusting person...) it seems 
>> there might at this stage only be very few offenders left.

utz> I have to recompile the fedora kernel rpms (fc6, f7) with 8k
utz> stacks on my i686 server. It's using NFS -> XFS -> DM -> MD
utz> (raid1) -> IDE disks.  With 4k stacks it crash (hang) within
utz> minutes after using NFS.  With 8k stacks it's rock solid. No
utz> crashes within months.

Does it give any useful information when it does crash?  Can you make
a simple test case using ram disks instead of IDE disks and then
building upon that?  

I think I should try to do this myself at some point...

John
