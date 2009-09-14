Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286AbZINEq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbZINEq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 00:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZINEq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 00:46:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60802
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbZINEq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 00:46:27 -0400
Date: Sun, 13 Sep 2009 21:46:44 -0700 (PDT)
Message-Id: <20090913.214644.164044855.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.moore@hp.com, jmorris@namei.org, mst@redhat.com
Subject: Re: linux-next: security-testing/net tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090914130154.8b6df8f9.sfr@canb.auug.org.au>
References: <20090903161432.44af630d.sfr@canb.auug.org.au>
	<20090914130154.8b6df8f9.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 14 Sep 2009 13:01:54 +1000

> On Thu, 3 Sep 2009 16:14:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Today's linux-next build (powerpc ppc64_defconfig) failed like this (this
>> was reverting to the security-testing tree in next-20090902):
>> 
>> drivers/net/tun.c: In function 'tun_set_iff':
>> drivers/net/tun.c:937: error: 'struct tun_struct' has no member named 'sk'
>> 
>> Caused by commit 2b980dbd77d229eb60588802162c9659726b11f4 ("lsm: Add
>> hooks to the TUN driver") interacting with commit
>> 89f56d1e91cfa535ccc6cc60e9e12e02682fd972 ("tun: reuse struct sock
>> fields") from the net tree.
>> 
>> I applied the following merge fix patch (which I can carry as necessary):
> 
> This patch now needs to be applied to the net tree (as the
> security-testing tree has been merged by Linus).  I have applied it as a
> merge fix for today.

Ok, since I already sent a merge request to Linus I'll submit this
as soon as he does that pull.

I don't like "slipping" in things to a tree I've already asked
him to pull from, and in this case especially since I'd have
to merge his tree in to keep net-next-2.6 itself building.
:-)
