Return-Path: <linux-kernel-owner+w=401wt.eu-S1031182AbXDQTqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031182AbXDQTqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031189AbXDQTqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:46:09 -0400
Received: from mail.enyo.de ([212.9.189.167]:4843 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031182AbXDQTqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:46:08 -0400
X-Greylist: delayed 1303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 15:46:08 EDT
From: Florian Weimer <fw@deneb.enyo.de>
To: Theodore Tso <tytso@mit.edu>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <op.tqw1g6n0ftfxs2@localhost.localdomain>
	<20070417131045.GB18373@thunk.org>
	<Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
	<200704171222.19892.dhazelton@enter.net>
	<20070417175055.GA24963@thunk.org>
Date: Tue, 17 Apr 2007 21:24:07 +0200
In-Reply-To: <20070417175055.GA24963@thunk.org> (Theodore Tso's message of
	"Tue, 17 Apr 2007 13:50:55 -0400")
Message-ID: <87odlmrei0.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Theodore Tso:

> we can continue trying to innovate around better filesystem and LVM
> storage technologies, as opposed to trying to chase the ZFS tail
> lights.

Indeed.  Here's a gem from the official ZFS FAQ:

| What can I do if ZFS panics on every boot?
| 
|     ZFS is designed to survive arbitrary hardware failures through the
|     use of redundancy (mirroring or RAID-Z). Unfortunately, certain
|     failures in non-replicated configurations can cause ZFS to panic
|     when trying to load the pool. This is a bug, and will be fixed in
|     the near future (along with several other nifty features like
|     background scrubbing and the ability to see a list of corrupted
|     files). In the meantime, if you find yourself in the situation
|     where you cannot boot due to a corrupt pool, do the followng:
| 
|        1. boot using '-m milestone=none'
|        2. # mount -o remount /
|        3. # rm /etc/zfs/zpool.cache
|        4. # reboot
| 
|     This will remove all knowledge of pools from your system. You will
|     have to re-create your pool and restore from backup.

<http://opensolaris.org/os/community/zfs/faq/#zfspanic>

I keep hoping that this FAQ entry is outdated, but the date on that
page is rather current. 8-/
