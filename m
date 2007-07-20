Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbXGTLiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbXGTLiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbXGTLha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:37:30 -0400
Received: from [212.12.190.239] ([212.12.190.239]:33099 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751527AbXGTLh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:37:26 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-raid@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 14:29:44 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200707200813.03553.a1426z@gawab.com> <46A05A84.6050305@wolfmountaingroup.com>
In-Reply-To: <46A05A84.6050305@wolfmountaingroup.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707201429.44915.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey V. Merkey wrote:
> Al Boldi wrote:
> >As always, a good friend of mine managed to scratch my partion table by
> >cat'ing /dev/full into /dev/sda.  I was able to push him out of the way,
> > but at least the first 100MB are gone.  I can probably live without the
> > first partion, but there are many partitions after that, which I hope
> > should easily be recoverable.
> >
> >I tried parted, but it's not working out for me.  Does anybody know of a
> >simple partition recovery tool, that would just scan the disk for lost
> >partions?
>
> One thing NetWare always did was to stamp a copy of the partition table
> at the time a partition was created as the second logical sector (offset
> 1) from the start of a newly created partition. This allowed the disk to
> be scanned for the original (or last) partition table copy.

This is really a good idea, as this would save you the trouble of 
reconstructing the table due to older overlapping entries.

Can linux do something like that?


Thanks!

--
Al

