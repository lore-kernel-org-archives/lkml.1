Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZAJT5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZAJT5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 14:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZAJT5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 14:57:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51504 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZAJT5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 14:57:44 -0500
Message-ID: <4968FDA7.5040008@garzik.org>
Date: Sat, 10 Jan 2009 14:57:27 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?J=F6rn_En?= =?ISO-8859-1?Q?gel?= <joern@logfs.org>,
       Ingo Molnar <mingo@elte.hu>, David Brown <lkml@davidb.org>,
       Phil Oester <kernel@linuxace.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com> <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <alpine.LFD.2.00.0901101015290.6528@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901101015290.6528@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I think squashfs usage would be similar - you'd not have squashfs as a 
> standalone media, it would be a "installation medium" thing.


Plenty of existing, active squashfs use on router firewall standalone 
media.   Here is my home router running unmodified OpenWRT:

root@gw:~# mount
rootfs on / type rootfs (rw)
/dev/root on /rom type squashfs (ro)
none on /dev type devfs (rw)
none on /proc type proc (rw)
none on /tmp type tmpfs (rw,nosuid,nodev)
none on /dev/pts type devpts (rw)
/dev/mtdblock/4 on /jffs type jffs2 (rw)
mini_fo:/jffs on / type mini_fo (rw)

The squashfs area stores the vast majority of the system; log files and 
other writable updates to the router go into the smaller jffs2 
filesystem.  Symlinks stitch the whole mess together.

It will be nice to finally get squashfs in the kernel, since it is 
actively used all over the place in embedded projects like OpenWRT.

Regards,

	Jeff


