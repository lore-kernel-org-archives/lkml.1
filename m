Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZCMKF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZCMKF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZCMKFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:05:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:50852 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZCMKFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:05:13 -0400
Date: Fri, 13 Mar 2009 19:04:18 +0900 (JST)
Message-Id: <20090313.190418.110778375.ryusuke@osrg.net>
To: raa.lkml@gmail.com
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org, hch@lst.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Asking for inclusion of nilfs2 in the mainline kernel
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <81b0412b0903130105y2f9c2430iabaab26d6a8e8188@mail.gmail.com>
References: <20090311.015542.118514963.ryusuke@osrg.net>
	<81b0412b0903130105y2f9c2430iabaab26d6a8e8188@mail.gmail.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 13 Mar 2009 19:04:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Fri, 13 Mar 2009 09:05:53 +0100, Alex Riesen wrote:
> 2009/3/10 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>:
> >
> > # mount -t nilfs2 -r -o cp=33339 /dev/sdb1 /snap
> > (mount the snapshot, then it will become accessible on the mount=
 point)
>
> Is it possible to mount a snapshot rw to make it a branch?

No, the writable snapshot is not supported.
( So, a readonly option appears in the example. )

Maybe the current design is unfit for efficient branching because
nilfs identifies checkpoints with linear numbers and manages lifetime
of each on-disk block with a range of the numbers.

We might be able to add a feature like replacing the latest filesystem
state with a past snapshot, but it's not yet determined.

Cheers,
Ryusuke
