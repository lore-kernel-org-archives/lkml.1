Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbXEQLLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbXEQLLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 07:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXEQLLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 07:11:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:49729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbXEQLLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 07:11:38 -0400
From: Neil Brown <neilb@suse.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date: Thu, 17 May 2007 21:11:17 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17996.14421.769180.782589@notabene.brown>
Cc: Jeff Zheng <Jeff.Zheng@endace.com>, david@lang.hm,
       Andreas Dilger <adilger@clusterfs.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
In-Reply-To: message from Jan Engelhardt on Thursday May 17
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<20070516140452.GC5286@schatzie.adilger.int>
	<Pine.LNX.4.64.0705161058430.1280@asgard.lang.hm>
	<Pine.LNX.4.61.0705162016060.9019@yvahk01.tjqt.qr>
	<659F626D666070439A4A5965CD6EBF406B3324@gazelle.ad.endace.com>
	<Pine.LNX.4.61.0705170918480.1791@yvahk01.tjqt.qr>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 17, jengelh@linux01.gwdg.de wrote:
> XOR it (0^0=1), and hence fills up the host disk.

Uhmm... you need to check your maths.

$ perl -e 'printf "%d\n", 0^0;'
0

:-)
NeilBrown
