Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbXEQHYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbXEQHYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 03:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXEQHYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 03:24:35 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52036 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXEQHYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 03:24:34 -0400
Date: Thu, 17 May 2007 09:21:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jeff Zheng <Jeff.Zheng@endace.com>
cc: david@lang.hm, Andreas Dilger <adilger@clusterfs.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: RE: Software raid0 will crash the file-system, when each disk is
 5TB
In-Reply-To: <659F626D666070439A4A5965CD6EBF406B3324@gazelle.ad.endace.com>
Message-ID: <Pine.LNX.4.61.0705170918480.1791@yvahk01.tjqt.qr>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
 <20070516140452.GC5286@schatzie.adilger.int> <Pine.LNX.4.64.0705161058430.1280@asgard.lang.hm>
 <Pine.LNX.4.61.0705162016060.9019@yvahk01.tjqt.qr>
 <659F626D666070439A4A5965CD6EBF406B3324@gazelle.ad.endace.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17 2007 09:42, Jeff Zheng wrote:
>
>Problem is that is only happens when you actually write data to the
>raid. You need the actual space to reproduce the problem.

That should not be a big problem. Create like 4x950G virtual sparse
drives (takes roughly or so 4x100 MB on the host after mkfs), then
set up a raid inside the vm, with which you can play - even write
to it. Not sure how RAID5 will affect the host size of the virtual
drives, since during first resync when all disks are blank, it will
XOR it (0^0=1), and hence fills up the host disk.


	Jan
-- 
