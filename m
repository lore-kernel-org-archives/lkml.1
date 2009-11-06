Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbZKFWpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbZKFWpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932627AbZKFWpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:45:51 -0500
Received: from kroah.org ([198.145.64.141]:56729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292AbZKFWWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:35 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:41 2009
Message-Id: <20091106221541.312749218@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [20/99] dm log: userspace fix incorrect luid cast in userspace_ctr
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dm-log-userspace-fix-incorrect-luid-cast-in-userspace_ctr.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andrew Morton <akpm@linux-foundation.org>

commit bca915aae803cf01fde4461fc9c093cf5a86d7fc upstream.

mips:

drivers/md/dm-log-userspace-base.c: In function `userspace_ctr':
drivers/md/dm-log-userspace-base.c:159: warning: cast from pointer to integer of different size

Cc: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-log-userspace-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -156,7 +156,7 @@ static int userspace_ctr(struct dm_dirty
 	}
 
 	/* The ptr value is sufficient for local unique id */
-	lc->luid = (uint64_t)lc;
+	lc->luid = (unsigned long)lc;
 
 	lc->ti = ti;
 


