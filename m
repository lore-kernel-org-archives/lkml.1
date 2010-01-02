Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668Ab0ABKdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0ABKdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 05:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599Ab0ABKdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 05:33:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:4013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0ABKdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 05:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=V9gsM/tPMtD3gcJx1rdqImQaXhItaIUi2ZBY8oIkrLQ9EnCD0vuDXOBk03H5J4NvLl
         KyEqhXk4ljIrf01hCq1VYz7GbUz4Ncppuu7T1eqhqcjo7oVkMvSffi8zzvO2d/5iJzjO
         cDVPxJXcF9wPeKddkOSDyT7vne4VoMkDrJd4E=
Date: Sat, 2 Jan 2010 11:32:27 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: 2.6.33-rc2+ bug in fs/btrfs/ordered-data.c:672
Message-ID: <20100102103227.GA3678@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started testing btrfs for my /home a few days ago and yesterday
I hit a kernel bug, using 2.6.33-rc2-00187-g08d869a.

I wasn't doing any stress test with it, I was simply watching a
DVD with xine while chrome was open in another workspace.

I noticed the kernel bug when the movie was over and I typed
'echo mem > /sys/power/state' to go to sleep but it got stuck,
so I checked what was happening in dmesg and I saw the bug in there.
By looking at the printk timings the bug was there for ~16 minutes, so
that last suspend to RAM atempt was not guilty in this bug. However,
the laptop was turned on for some hours already and had already passed
through a few suspend to RAM in this period.

I tried to save the dmesg but it failed writing, so I took a picture
of the bug trace

http://www.aei.mpg.de/~crmafra/btrfs_bug.jpg

Some info about my laptop is in this dmesg from this morning

http://www.aei.mpg.de/~crmafra/dmesg-2.6.33-rc2.txt

I hope this helps.


