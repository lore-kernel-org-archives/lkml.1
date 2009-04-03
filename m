Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZDCCpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZDCCpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZDCCpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:45:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56392 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbZDCCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:45:27 -0400
Date: Thu, 2 Apr 2009 19:45:24 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Theodore Tso <tytso@mit.edu>
cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS
In-Reply-To: <20090403020525.GI9870@mit.edu>
Message-ID: <alpine.DEB.2.01.0904021938560.6162@bogon.housecafe.de>
References: <49CCCB0A.6070701@nokia.com> <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de> <20090403020525.GI9870@mit.edu>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18UGK10hHDJmQQei/8iYJdBM2yiT5yaFSsy1ZQ
 St/XP+6IgTEaAD1W6OhlbGJ1ef2Q1jfkMDlsR6goLIrv4nB9IM
 nHa3QpgV7u2kH0DgEt4XQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Theodore Tso wrote:
> It will, but you might not like the performance....  the reason why
> it's there is that some users might want the particular tradeoff, but
> it probably wouldn't make a good default.

Thanks for confirming this. Yes, I know about the performance impact, but 
perhaps it's feasible for some setups.

Christian.

PS: I was curious *how* bad the impact was and so I tried generating a
    477 MB tarball, first on an async, then on an sync mounted partition:

   /dev/md0 /mnt/md0 ext4 rw,noatime,barrier=1,data=ordered
   $ time tar -cf /mnt/md0/test.tar /usr
   real	1m36.615s

   /dev/md0 /mnt/md0 ext4 rw,sync,noatime,barrier=1,data=ordered
   $ time tar -cf /mnt/md0/test.tar /usr
   real	5m23.793s

-- 
Bruce Schneier does not get kidney stones. He gets Rosetta Stones.
