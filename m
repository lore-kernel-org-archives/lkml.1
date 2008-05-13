Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYEMCT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYEMCT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 22:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbYEMCTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 22:19:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:50293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665AbYEMCTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 22:19:18 -0400
From: Neil Brown <neilb@suse.de>
To: Kasper Sandberg <lkml@metanurb.dk>
Date: Tue, 13 May 2008 12:19:10 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18472.64158.98047.226081@notabene.brown>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops on -rc2-git1, possibly md_raid1 or xfs related. (Was: Re:
	Linux 2.6.26-rc2)
In-Reply-To: message from Kasper Sandberg on Tuesday May 13
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org>
	<1210643358.1093.14.camel@localhost>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday May 13, lkml@metanurb.dk wrote:
> ------------[ cut here ]------------
> WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x71/0xa0()
> Modules linked in:
> Pid: 460, comm: md1_raid1 Not tainted 2.6.26-rc2-git1 #1

Fix is here:
  http://lkml.org/lkml/2008/5/12/359

NeilBrown
