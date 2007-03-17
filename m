Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbXCQVBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbXCQVBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 17:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXCQVBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 17:01:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:38570 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbXCQVBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 17:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ooA9N/wWmS8HJ4TersRbyURMxY6OLo33aIRZcecFo17d9h5kgku1A5DVWfgS8s5PdZm17rS/cIQiyBTjU9oqWSWB7eokRqMOx19LNqb7wUJGFwpAXt/nlMqf7HRFz97fmovRXrW8E4EINpTc3uYRWsy03FzCRow/jr2+r0EwwXY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
Subject: Re: [PATCH 1/2] scc_pata: dependency fix
Date: Sat, 17 Mar 2007 21:50:10 +0100
User-Agent: KMail/1.9.6
Cc: torvalds@linux-foundation.org, Al Viro <viro@ftp.linux.org.uk>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <200703160203.l2G23QgI022196@toshiba.co.jp>
In-Reply-To: <200703160203.l2G23QgI022196@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172150.11143.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 16 March 2007, Akira Iguchi wrote:
> This patch fixes:
> * the dependency of scc_pata on BLK_DEV_IDEDMA_PCI
> * incorrect link to ide-core
> * move scc_pata from ide/ppc to ide/pci
> 
> Signed-off-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
> Signed-off-by: Akira Iguchi <akira2.iguchi@toshiba.co.jp>

I applied both patches after:

* manually fixing the reject in drivers/ide/Kconfig
  (because Al's "IDE=y" fix has already been applied)

* merging patch #1 and #2 into a single one
  (otherwise patch #1 alone breaks kernel build)

Thanks,
Bart
