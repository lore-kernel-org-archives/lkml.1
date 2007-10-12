Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbXJLRPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbXJLRPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXJLRPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:15:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbXJLRPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:15:09 -0400
Date: Fri, 12 Oct 2007 18:14:55 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>, stable@kernel.org
Subject: [2.6.24 PATCH 07/25] dm delay: fix status
Message-ID: <20071012171455.GR24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>, stable@kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

Fix missing space in dm-delay target status output
if separate read and write delay are configured.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-delay.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-delay.c	2007-10-12 13:15:33.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-delay.c	2007-10-12 13:15:34.000000000 +0100
@@ -308,7 +308,7 @@ static int delay_status(struct dm_target
 		       (unsigned long long) dc->start_read,
 		       dc->read_delay);
 		if (dc->dev_write)
-			DMEMIT("%s %llu %u", dc->dev_write->name,
+			DMEMIT(" %s %llu %u", dc->dev_write->name,
 			       (unsigned long long) dc->start_write,
 			       dc->write_delay);
 		break;
