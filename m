Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbXFUQQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbXFUQQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbXFUQPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:15:53 -0400
Received: from mail.fieldses.org ([66.93.2.214]:59358 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbXFUQPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:15:53 -0400
Date: Thu, 21 Jun 2007 12:15:31 -0400
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 007 of 8] knfsd: nfsd4: vary maximum delegation limit based on RAM size
Message-ID: <20070621161531.GC4094@fieldses.org>
References: <20070621142604.727.patches@notabene> <1070621043112.1144@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070621043112.1144@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I missed a compile warning here, apologies.

--b.

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c79f742..fbbbcab 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3204,7 +3204,7 @@ get_nfs4_grace_period(void)
 }
 
 static void
-set_max_delegations()
+set_max_delegations(void)
 {
 	struct sysinfo sys;
