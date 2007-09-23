Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbXIWPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbXIWPcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXIWPcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 11:32:01 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:13307 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbXIWPb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XyJAZ9PdeeOaPRD2ZQt4Xv0o3nhWxBElR5lTkxOB6gfS5eE4Auqk3DQGjKIbzfg4vhoQkq1FLBRMaLjmaUUB1HDhrFh/CblCydQKNHtUSk0SdD1m8PcoZnx0jVruywhXIztGD+0Ilm80q8eqaxj4KRMCIy3BKMHcjuPXl/lR18A=
Message-ID: <64bb37e0709230831t16eaa86dub5abcb97fdce12eb@mail.gmail.com>
Date: Sun, 23 Sep 2007 17:31:58 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "FUJITA Tomonori" <tomof@acm.org>
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
In-Reply-To: <20070923225320I.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070921085711.GG2367@kernel.dk>
	 <64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
	 <20070923225320I.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/07, FUJITA Tomonori <tomof@acm.org> wrote:
> On Sun, 23 Sep 2007 15:19:13 +0200
> "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> > To update the statistik:
> > prior to 2.6.23-rc4-mm1: no trouble with any drives on the SiI 3132.
> > 2.6.23-rc4-mm1 without patch: 2 out of 2 bad.
> > back to 2.6.23-rc3-mm1: 18x good.
> > 2.6.23-rc4-mm1 with patch:  2 out of 8 bad
> > after that second mail:
> > 2.6.23-rc4-mm1 with patch: 1 out of 5 bad
> > 2.6.23-rc6-mm1: 1 out of 2 bad
>
> git-block.patch in 2.6.23-rc6-mm1 includes my patch that disables sg
> chaining for libata but it still includes libata's sg chaining
> changes. So these changes breaks libata or libata was broken after
> 2.6.23-rc3-mm1.
>
> Can you try Jens's sglist-arch branch? If it works, probably libata in
> -mm has bugs.
>
> For your convenience, I put a sglist-arch branch patch against v2.6.23-rc7:
>
> http://www.kernel.org/pub/linux/kernel/people/tomo/misc/v2.6.23-rc7-sglist-arch.diff.bz2

Thanks for the patch.
I tried it and 3 out of 3 boot attempts worked without problems.
But I can't rule out that the bug is still there, as I have no way to
trigger it on demand.

Torsten
