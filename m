Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0CHCU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 21:20:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34076 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0CHCUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 21:20:50 -0500
Date: Mon, 8 Mar 2010 13:20:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mulyadi Santosa <mulyadi.santosa@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the trivial tree with Linus' tree
Message-Id: <20100308132043.f6dcc0cd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
Documentation/filesystems/proc.txt between commit
34e55232e59f7b19050267a05ff1226e5cd122a5 ("mm: avoid false sharing of
mm_counter") from Linus' tree and commit
cb2992a60b7e73fbabe9ffe54056eed0022f2ed2 ("doc: typo - Table 1-2 should
refer to "status", not "statm"") from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/filesystems/proc.txt
index 96a44dd,bb314f6..0000000
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@@ -189,13 -188,7 +189,13 @@@ memory usage. Its seven fields are expl
  contains details information about the process itself.  Its fields are
  explained in Table 1-4.
  
 +(for SMP CONFIG users)
 +For making accounting scalable, RSS related information are handled in
 +asynchronous manner and the vaule may not be very precise. To see a precise
 +snapshot of a moment, you can see /proc/<pid>/smaps file and scan page table.
 +It's slow but very precise.
 +
- Table 1-2: Contents of the statm files (as of 2.6.30-rc7)
+ Table 1-2: Contents of the status files (as of 2.6.30-rc7)
  ..............................................................................
   Field                       Content
   Name                        filename of the executable
