Return-Path: <linux-kernel-owner+w=401wt.eu-S1765376AbXHDRwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765376AbXHDRwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764923AbXHDRwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:52:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:28726 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764893AbXHDRwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=amsBsmCXOJfuDE5nSxoV9jjNSngktP90oWVGB/CLJxxWQZcOApD0m5dEeuoZGv/X3WTVprbwgetbmD7TF8kpBDMHyQQN6AL5mT0x4Yu0qrm1RbCEKxbyI5mCwI6FNoysbdU8FJ6HaHsgsQYw4ndzu40svZ8/BwG+bYJykeYwsCU=
Date: Sat, 4 Aug 2007 19:51:22 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Diego Calleja <diegocg@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-Id: <20070804195122.af163272.diegocg@gmail.com>
In-Reply-To: <20070804193801.d310d025.diegocg@gmail.com>
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu>
	<20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
	<20070804190210.8b1530dd.diegocg@gmail.com>
	<20070804171724.GA4740@elte.hu>
	<20070804193801.d310d025.diegocg@gmail.com>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 4 Aug 2007 19:38:01 +0200, Diego Calleja <diegocg@gmail.com> escribió:

> Mmmh, "mount -o remount,noatime /" seems to Work For Me in Ubuntu
> with util-linux/mount "2.12r-17ubuntu"...but then Google says [1] that
> Ubuntu has been shipping with relatime enabled as default for months,
                                                           ^^^^^

Obviously, i meant "noatime"...(so it's unlikely that ubuntu has patched
anything to support relatime - it's not reflected in the changelogs at least)

> so it's probably patched (probably only in the kernel). So maybe upstream
> util-linux hasn't merged the relatime patch.
> 
> [1]: http://lkml.org/lkml/2007/2/12/30
