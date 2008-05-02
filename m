Return-Path: <linux-kernel-owner+w=401wt.eu-S935103AbYEBWOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935103AbYEBWOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbYEBWOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:14:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758019AbYEBWOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:14:23 -0400
Date: Fri, 2 May 2008 15:12:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-next@vger.kernel.org
Cc: Steven French <sfrench@us.ibm.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Ralf Baechle <ralf@linux-mips.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>, Jan Kara <jack@ucw.cz>,
       Anton Vorontsov <cbou@mail.ru>, Jens Axboe <jens.axboe@oracle.com>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Wim Van Sebroeck <wim@iguana.be>, Christian Zankel <chris@zankel.net>,
       Nicolas Pitre <nico@cam.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org
Subject: git trees which are not yet in linux-next
Message-Id: <20080502151206.b40f77ea.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


git-cifs: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git

git-gfs2-nmw: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git

git-ieee1394: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git#for-mm

git-jg-misc: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git#irq-remove

git-libata-all: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-2.6.git

git-mips: git://git.linux-mips.org/pub/scm/upstream-akpm.git#mips-for-mm

git-mmc: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git#for-andrew

git-udf: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git#for_mm

git-battery: git://git.infradead.org/battery-2.6.git

git-block: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#for-akpm

git-v9fs: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git#v9fs-devel

git-watchdog: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog-mm.git

git-xtensa: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/czankel/xtensa-2.6.git#testing

git-orion: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/nico/orion.git

git-pekka: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git#for-mm


(This list is probably incomplete - there might be other trees which are
presently empty but which aren't in linux-next yet)

(Jeff, git-libata-all is a pretty important one)

Guys, could you please prepare a tree for Stephen and send the details
over to him?  Please Cc me also.

Once this has happened, there should be no need to run a separate for-mm
branch.  I'll just switch over to using whatever branch linux-next is
using.

I'll continue to pull all the git trees, although I'll expect to drop them
again.  I will do this to keep my list of git URLs fresh.  So if for some
reason linux-next isn't getting updated I can drop it and switch back to
the individual git trees.


I don't yet know how I'll get along basing -mm on linux-next.  The first
problem is working out "how the heck did that patch get into linux-next"? 
That would be much easier if the signoff trail was complete for git-based
patches, but it often is not.

Thanks.

(git-unionfs and such things will remain -mm-only)
