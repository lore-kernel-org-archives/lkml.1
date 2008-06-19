Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbYFSE3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbYFSE3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 00:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYFSE3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 00:29:11 -0400
Received: from mx1.suse.de ([195.135.220.2]:57464 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYFSE3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 00:29:10 -0400
From: Neil Brown <neilb@suse.de>
To: Jan De Luyck <ml_linuxkernel_20060528@kcore.org>
Date: Thu, 19 Jun 2008 14:29:03 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18521.57487.410817.953075@notabene.brown>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Raid auto-assembly on LDM?
In-Reply-To: message from Jan De Luyck on Sunday June 15
References: <485577EE.9050806@kcore.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday June 15, ml_linuxkernel_20060528@kcore.org wrote:
> Hello folks,
> 
> I'm trying something which is probably slightly crazy, but I can't get it to work.
> 
> What I'm trying is to get the linux kernel to auto-assembly my raid-1 sets, 
> which are based on volumes on two LDM disks.
> 
> The problem is that the kernel looks for partitiontypes of 0xfd, which I can't 
> set (or haven't found yet how to set) for LDM volumes. The assembly fails, and 
> the kernel panics.

Sorry, acronym failure:  What is LDM??

> 
> Another possibility would be to use an initrd/initramfs, but then I'm once again 
> stuck with a disk that is not in raid, and ergo a point of failure when the disk 
> might crash.

I don't understand your conclusion.
The initrd/initramfs is stored where ever your kernel is stored.  If
storing an initrd introduces a single point of failure, then storing
your Linux kernel will too.


Confused.

NeilBrown 


> 
> (The reason to use LDM is that this way I also can put the other OS on the disk 
> in mirror.)
> 
> Does anyone have any other ideas? I've searched the web, but noone really seems 
> inclined to do it this way...
> 
> Kind regards,
> 
> Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
