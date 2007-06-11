Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbXFKOeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbXFKOeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbXFKOeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:34:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38677 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbXFKOeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:34:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.22-rc4-mm2: GPF during suspend to RAM on HPC nx6325
Date: Mon, 11 Jun 2007 16:41:02 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <200706110102.52946.rjw@sisk.pl> <466CF71B.2000907@gmail.com>
In-Reply-To: <466CF71B.2000907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111641.03349.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 June 2007 09:17, Tejun Heo wrote:
> Hello, Rafael.
> 
> Rafael J. Wysocki wrote:
> > gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch breaks
> > suspend to RAM on HPC nx6325 (x86_64).
> > 
> > With this patch applied I get a general protection fault in mutex_lock+0x15
> > (kernel/mutex.c:91), called by sysfs_hash_and_remove() (fs/sysfs/inode.c:298),
> > called by threshold_cpu_callback(), called from _cpu_down().
> 
> I'm not sure whether this is bug in sysfs or in sysfs handling code in
> mce_amd and I can't test mce_amd here.  Can you please apply the
> attached patch and post the resulting dmesg including oops?

I'd rather won't be able to get an oops from the affected machine (VGA console
only), but I'll try it on another one.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
