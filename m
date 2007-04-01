Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbXDAC5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbXDAC5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 22:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXDAC5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 22:57:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:59329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbXDAC5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 22:57:48 -0400
From: Neil Brown <neilb@suse.de>
To: "Florian D." <flockmock@gmx.at>
Date: Sun, 1 Apr 2007 12:57:41 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17935.8101.815473.709581@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cannot add device to partitioned raid6 array
In-Reply-To: message from Florian D. on Saturday March 31
References: <460EF263.7020505@gmx.at>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday March 31, flockmock@gmx.at wrote:
> hi list!
> 
> in short:
> I created a partitioned raid6 array with 2 missing drives. Now, I want to add a device. It fails with:
> flockmock ~ # mdadm -a /dev/md_d4 /dev/sdb2
> mdadm: add new device failed for /dev/sdb2 as 4: Invalid argument

Thanks for the detailed problem report.

I think the cause of the error is that /dev/sdb2 is too small.
It needs to be at least 490030594 sectors. How big is it?

Yes, both the kernel an mdadm should handle this case better.
I have made a note to look into this.

NeilBrown
