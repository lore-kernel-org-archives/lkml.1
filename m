Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYA3KD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYA3KD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYA3KDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:03:50 -0500
Received: from styx.suse.cz ([82.119.242.94]:49232 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752166AbYA3KDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:03:50 -0500
Date: Wed, 30 Jan 2008 11:03:48 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add documentation for isofs dmode option
Message-ID: <20080130100348.GA16140@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Andrew,

  I'm resending this oneliner... You seem to have missed it in my reply (or
at least I haven't seen it merged yet).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Add documentation to for new dmode option.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/Documentation/filesystems/isofs.txt b/Documentation/filesystems/isofs.txt
index 758e504..6973b98 100644
--- a/Documentation/filesystems/isofs.txt
+++ b/Documentation/filesystems/isofs.txt
@@ -24,6 +24,7 @@ Mount options unique to the isofs filesystem.
   map=normal    Map non-Rock Ridge filenames to lower case
   map=acorn     As map=normal but also apply Acorn extensions if present
   mode=xxx      Sets the permissions on files to xxx
+  dmode=xxx     Sets the permissions on directories to xxx
   nojoliet      Ignore Joliet extensions if they are present.
   norock        Ignore Rock Ridge extensions if they are present.
   hide		Completely strip hidden files from the file system.
