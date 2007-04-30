Return-Path: <linux-kernel-owner+w=401wt.eu-S1423163AbXD3I4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423163AbXD3I4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 04:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423164AbXD3I4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 04:56:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:38076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423163AbXD3I4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:56:14 -0400
From: Neil Brown <neilb@suse.de>
To: Zan Lynx <zlynx@acm.org>
Date: Mon, 30 Apr 2007 18:55:52 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17973.44824.631204.926723@notabene.brown>
Cc: Adrian Bunk <bunk@stusta.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
In-Reply-To: message from Zan Lynx on Saturday April 28
References: <20070428191927.GN3468@stusta.de>
	<1177795118.7828.6.camel@localhost>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday April 28, zlynx@acm.org wrote:
> On Sat, 2007-04-28 at 21:19 +0200, Adrian Bunk wrote:
> > 4k stacks have become a well-tested feature used fore a long time in
> > Fedora and even in RHEL 4.
> 
> So has anyone fixed the bugs involving ext3 and LVM snapshots on top of
> DM mirror?

Well -mm has a patch which makes stacked block devices much less of an
issue, but this hasn't made it -linus yet - I think the dm developer
isn't happy that dm works properly with it.

> 
> Our 32-bit Fedora Core 5 dual Opteron server at work crashed once a week
> while running rdiff-backup off a snapshot.  Installing a 64-bit kernel
> stopped the crashes, and I believe the 64-bit still uses the bigger
> stacks.

I wonder if FC-4 has the generic_make_request patch as well as 4K
stacks.  If does, then there is obviously something else to be fixed.
If it doesn't, then maybe that is all that is needed.

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/md-dm-reduce-stack-usage-with-stacked-block-devices.patch

NeilBrown
