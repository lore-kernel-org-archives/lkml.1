Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXEGAfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXEGAfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXEGAfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:35:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXEGAfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:35:32 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 7 May 2007 10:35:09 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: [PATCH 000 of 8] knfsd: Assorted bugfixes for 2.6.22
Message-ID: <20070507103211.23855.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 8 patches for knfsd and related code that are suitable for
2.6.22.

First two are suitable for -stable: they can cause an oops.
(8 can also cause an oops, but you really need buggy userspace code 
running as root, and it is a larger patch than I like to send to -stable).

Other 6 are less significant bug fixes and cleanups.

Thanks,
NeilBrown


 [PATCH 001 of 8] knfsd: Avoid use of unitialised variables on error path when nfs exports.
 [PATCH 002 of 8] knfsd: rpc: fix server-side wrapping of krb5i replies
 [PATCH 003 of 8] knfsd: Fix resource leak resulting in module refcount leak for	rpcsec_gss_krb5.ko
 [PATCH 004 of 8] knfsd: rpcgss : RPC_GSS_PROC_ DESTROY request will get a bad rpc
 [PATCH 005 of 8] knfsd: Simplify a 'while' condition in svcsock.c
 [PATCH 006 of 8] knfsd: Trivial makefile cleanup
 [PATCH 007 of 8] knfsd: Various nfsd xdr cleanups.
 [PATCH 008 of 8] knfsd: Avoid Oops if buggy userspace performs confusing filehandle->dentry mapping.
