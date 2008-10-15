Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYJOBVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYJOBVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYJOBVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:21:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59134 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYJOBVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:21:23 -0400
Date: Tue, 14 Oct 2008 18:20:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mark Fasheh <mfasheh@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git patches] Ocfs2 features for 2.6.28 (build errors)
Message-Id: <20081014182037.38503fd0.randy.dunlap@oracle.com>
In-Reply-To: <20081014200319.GK15154@wotan.suse.de>
References: <20081014200319.GK15154@wotan.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 13:03:19 -0700 Mark Fasheh wrote:

> Hi Linus,
> 
> 	The majority of these Ocfs2 patches were sent to the list back in
> September:
> 
> 	http://lkml.org/lkml/2008/9/24/383
> 
> All feedback has been incorporated - my original e-mail describing the
> contents of our tree is attached below.
> 
> The only exception is that I added (after the initial send to lkml) an
> internal api cleanup series from Joel. This doesn't really make any
> functional changes, but simplifies our block I/O handling code in
> anticipation of some features we're planning for 2.6.29. For reference,
> these changes are the topmost 6 patches in the branch. I don't think they're
> are particularly controversial or tricky.
> 	--Mark
> 
> Please pull from 'upstream-linus' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus


In 2.6.27-git5 I am seeing build errors as follow:

fs/ocfs2/xattr.c: In function 'ocfs2_xattr_bucket_find':
fs/ocfs2/xattr.c:2352: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c:2352: error: (Each undeclared identifier is reported only once
fs/ocfs2/xattr.c:2352: error: for each function it appears in.)
fs/ocfs2/xattr.c: In function 'ocfs2_iterate_xattr_buckets':
fs/ocfs2/xattr.c:2429: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c: In function 'ocfs2_xattr_update_xattr_search':
fs/ocfs2/xattr.c:2697: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c: In function 'ocfs2_defrag_xattr_bucket':
fs/ocfs2/xattr.c:2902: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c: In function 'ocfs2_read_xattr_bucket':
fs/ocfs2/xattr.c:3157: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
fs/ocfs2/xattr.c: In function 'ocfs2_xattr_set_entry_in_bucket':
fs/ocfs2/xattr.c:4104: error: 'OCFS2_BH_CACHED' undeclared (first use in this function)
make[2]: *** [fs/ocfs2/xattr.o] Error 1


---
~Randy
