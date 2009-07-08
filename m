Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbZGHVmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbZGHVmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbZGHVml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:42:41 -0400
Received: from mail.samba.org ([66.70.73.150]:47674 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019AbZGHVmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:42:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19029.4803.604820.157625@samba.org>
Date: Thu, 9 Jul 2009 07:42:27 +1000
To: paulmck@linux.vnet.ibm.com
Cc: Pavel Machek <pavel@ucw.cz>, Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090708142520.GA7817@linux.vnet.ibm.com>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090702214646.GD1485@ucw.cz>
	<19021.12158.915384.574218@samba.org>
	<20090702223349.GA30840@elf.ucw.cz>
	<19021.14217.587592.808935@samba.org>
	<20090702224446.GD30840@elf.ucw.cz>
	<19021.18919.560478.630755@samba.org>
	<20090708092133.GC24385@elf.ucw.cz>
	<20090708142520.GA7817@linux.vnet.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

These probabilities are way off. They assume that whatever interaction
happens in XP has infinite memory. The testing I've done indicates
that the memory for this interaction is very small (maybe 3 or 4? it's
hard to know precisely).

I've also confirmed this with lots of testing. If the probability was
39% for any directory size then I would have found it.

In all my testing I did not once produce a XP crash with the full
patch. To produce the XP crash I needed to have a reduced version of
the patch with less randomness.

Cheers, Tridge
