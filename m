Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXDNUy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXDNUy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 16:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbXDNUy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 16:54:56 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45705 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXDNUyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 16:54:55 -0400
Date: Sat, 14 Apr 2007 22:53:23 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Mike Snitzer <snitzer@gmail.com>
cc: Neil Brown <neilb@suse.de>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
In-Reply-To: <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> 
 <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 14 2007 10:04, Mike Snitzer wrote:
>
> ZFS does have some powerful features but much of it depends on their
> broken layering of volume management.  Embedding the equivalent of LVM
> into a filesystem _feels_ quite wrong.
>
>[...]
>
> Unfortunately in order for Linux to incorporate such a feature I'd
> imagine a new filesystem would need to be developed with redirect on
> write at its core.  Can't really see ext4 or any other existing Linux
> filesystem grafting such a feature into it.  But even though I can't
> see it; do others?

FUSE-based filesystems. (That said, might wanna try through
"ZFS-on-fuse" fs).


Jan
-- 
