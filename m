Return-Path: <linux-kernel-owner+w=401wt.eu-S933013AbXBLFuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbXBLFuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 00:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXBLFuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 00:50:39 -0500
Received: from ns1.suse.de ([195.135.220.2]:33243 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933013AbXBLFuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 00:50:37 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 12 Feb 2007 16:49:35 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 4] knfsd: fixes and enhancements for 2.6.21
Message-ID: <20070212164133.26352.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 4 patchs from knfsd suitable for 2.6.21.

Numbers 3 and 4 provide new usability features that require a new
nfs-utils to make full use of (all nfs-utils will ofcourse continue to
work providing the functionality it always provided).

(3) allows a 16 byte uuid to be used to identify the filesystem rather
than the device id (which is volatile) or a 32bit number (which has to
be managed manually).  nfs-utils used libblkid to extract a uuid from
most filesystems. (Thanks Trond for reviewing this code - I hope you
like the changes).

(4) allows an upcall to be made to map a 'uid' to a list of 'gids'.
The AUTH_UNIX authentication protocol only carries 16 group ids which
causes problems for people with more than 16 group ids.

 [PATCH 001 of 4] knfsd: Fix return value for writes to some files in 'nfsd' filesystem.
 [PATCH 002 of 4] knfsd: Tidy up choice of filesystem-identifier when creating a filehandle.
 [PATCH 003 of 4] knfsd: Add some new fsid types.
 [PATCH 004 of 4] knfsd: Allow the server to provide a gid list when using AUTH_UNIX authentication.
