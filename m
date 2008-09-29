Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYI2Top@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYI2Top (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYI2Tof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:44:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48783 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYI2Toe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:44:34 -0400
Subject: [RFC] Btrfs mainline plans
From: Chris Mason <chris.mason@oracle.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 15:44:20 -0400
Message-Id: <1222717460.30627.56.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Thanks to help from David Woodhouse and Linus, I have btrfs source repos
migrated over to git.  My goal is to make the sources easier for people
to review, and to start some discussions around the best time to merge
Btrfs.

The current code has a number of problems (and this is not a complete
list):

* The disk format is not finalized
* ENOSPC can result in BUG()
* blocksize != pagesize does not work
* Error handling is missing in a number of places

But, the code is very actively developed, and I believe the best way to
develop Btrfs from here is to get it into the mainline kernel (with a
large warning label about the disk format) and attract more extensive
review of both the disk format and underlying code.

The Btrfs developers are committed to making the FS work and to working
well within the kernel community.  I think everyone will be happier with
the final result if I am able to attract eyeballs as early as possible.

The plan is to have the disk format finalized by the end of the year.  I
do expect to have a provisional disk format over the next 2 weeks that
should have all the moving pieces btrfs needs to implement the remaining
1.0 features, and I hope to restrict any additional format changes after
that to include backward compatibility.  

The sources:

Kernel module (against rc7):
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary


Btrfs progs:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=summary

General Btrfs information:

http://btrfs.wiki.kernel.org/

Most of the remaining features before 1.0:

http://btrfs.wiki.kernel.org/index.php/Development_timeline

-chris


