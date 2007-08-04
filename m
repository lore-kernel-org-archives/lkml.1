Return-Path: <linux-kernel-owner+w=401wt.eu-S1765206AbXHDRiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765206AbXHDRiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764829AbXHDRiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:38:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:21057 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810AbXHDRip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=XEr1TkyvoqqSzXCrti3jQxrf1FcoEF4fojUHgVYN336cE3p67RA65wnYqPCSDZuCzSy/nz4WzmrzbTogUpsAEsXekeOkq8fphfR9yzNHyh/uKoH1KD4R57iD76UjjMr3L0XhnkOAf0iVZdDuZkumXo/oGqR3tz0n2paKGBuie38=
Date: Sat, 4 Aug 2007 19:38:01 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-Id: <20070804193801.d310d025.diegocg@gmail.com>
In-Reply-To: <20070804171724.GA4740@elte.hu>
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu>
	<20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
	<20070804190210.8b1530dd.diegocg@gmail.com>
	<20070804171724.GA4740@elte.hu>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 4 Aug 2007 19:17:24 +0200, Ingo Molnar <mingo@elte.hu> escribió:

> i've got util-linux-2.13-0.46.fc6 and 2.6.22 on that box, shouldnt that 
> be recent enough? As far as i can see it from the kernel-side code, this 
> works on the general VFS level and hence should be supported by ext3 
> already.

Mmmh, "mount -o remount,noatime /" seems to Work For Me in Ubuntu
with util-linux/mount "2.12r-17ubuntu"...but then Google says [1] that
Ubuntu has been shipping with relatime enabled as default for months,
so it's probably patched (probably only in the kernel). So maybe upstream
util-linux hasn't merged the relatime patch.

[1]: http://lkml.org/lkml/2007/2/12/30
