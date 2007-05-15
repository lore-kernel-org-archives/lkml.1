Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbXEOHQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbXEOHQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXEOHQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:16:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:43219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbXEOHQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:16:27 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 15 May 2007 17:15:57 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: shaggy@austin.ibm.com
Subject: [PATCH 000 of 8] knfsd: cleanups for exportfs code.
Message-ID: <20070515170405.15621.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 8 patches from Christoph Hellwig which tidy up the
"exportfs" code used by nfsd for communicating with filesystems about
the handling of filehandles.

One change of note is that the old "iget" approach to filehandle
lookup is moved out of generic code and into the two filesystems that
still use it (including jfs: hence the Cc to shaggy@austin.ibm.com).

These are for -mm until 2.6.23 opens.
NeilBrown



 [PATCH 001 of 8] knfsd: exportfs: add exportfs.h header
 [PATCH 002 of 8] knfsd: exportfs: remove iget abuse
 [PATCH 003 of 8] knfsd: exportfs: add procedural interface for NFSD
 [PATCH 004 of 8] knfsd: exportfs: remove CALL macro
 [PATCH 005 of 8] knfsd: exportfs: untangle ISDIR logic in find_exported_dentry
 [PATCH 006 of 8] knfsd: exportfs: move acceptable check into find_acceptable_alias
 [PATCH 007 of 8] knfsd: exportfs: add find_disconnected_root helper
 [PATCH 008 of 8] knfsd: exportfs: split out reconnecting a dentry from find_exported_dentry.
