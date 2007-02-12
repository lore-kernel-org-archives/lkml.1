Return-Path: <linux-kernel-owner+w=401wt.eu-S1030499AbXBLXoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030499AbXBLXoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030505AbXBLXoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:44:34 -0500
Received: from ns2.suse.de ([195.135.220.15]:54938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030499AbXBLXod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:44:33 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Feb 2007 10:43:56 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 9] knfsd: NFSv4 ACL improvements and a couple of bug fixes.
Message-ID: <20070213103941.28958.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

following are 9 patches from Bruce Fields for the NFSv4 server,
mostly ACL related.
Suitable for 2.6.21.

Thanks,
NeilBrown


 [PATCH 001 of 9] knfsd: nfsd4: fix non-terminated string
 [PATCH 002 of 9] knfsd: nfsd4: relax checking of ACL inheritance bits
 [PATCH 003 of 9] knfsd: nfsd4: simplify nfsv4->posix translation
 [PATCH 004 of 9] knfsd: nfsd4: represent nfsv4 acl with array instead of linked list
 [PATCH 005 of 9] knfsd: nfsd4: fix memory leak on kmalloc failure in savemem
 [PATCH 006 of 9] knfsd: nfsd4: fix error return on unsupported acl
 [PATCH 007 of 9] knfsd: nfsd4: acls: don't return explicit mask
 [PATCH 008 of 9] knfsd: nfsd4: acls: avoid unnecessary denies
 [PATCH 009 of 9] knfsd: nfsd4: fix handling of directories without default ACLs
