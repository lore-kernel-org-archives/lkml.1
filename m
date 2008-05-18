Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYERN7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYERN7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 09:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYERN73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 09:59:29 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:58212 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbYERN72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 09:59:28 -0400
Date: Sun, 18 May 2008 16:59:26 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>, joel.becker@oracle.com,
       mfasheh@suse.com
Subject: OCFS2 printf format warnings
Message-ID: <Pine.SOC.4.64.0805181658030.22653@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just noticed these on sparc64:

  CC [M]  fs/ocfs2/cluster/netdebug.o
fs/ocfs2/cluster/netdebug.c: In function 'nst_seq_show':
fs/ocfs2/cluster/netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'suseconds_t'
fs/ocfs2/cluster/netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 15 has type 'suseconds_t'
fs/ocfs2/cluster/netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'suseconds_t'
fs/ocfs2/cluster/netdebug.c: In function 'sc_seq_show':
fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 19 has type 'suseconds_t'
fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'suseconds_t'
fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 23 has type 'suseconds_t'
fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 25 has type 'suseconds_t'
fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 27 has type 'suseconds_t'
fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 29 has type 'suseconds_t'

-- 
Meelis Roos (mroos@linux.ee)
