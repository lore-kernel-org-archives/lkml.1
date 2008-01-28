Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbYA1M7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbYA1M7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYA1M64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:58:56 -0500
Received: from styx.suse.cz ([82.119.242.94]:34123 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755191AbYA1M6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:58:55 -0500
Date: Mon, 28 Jan 2008 13:58:54 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gin@mo.msk.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement dmode option for isofs
Message-ID: <20080128125854.GB14038@duck.suse.cz>
References: <518x2n9jgn.fsf@mo.msk.ru> <20080123184752.GE23304@atrey.karlin.mff.cuni.cz> <20080126220210.196e679a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126220210.196e679a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 26-01-08 22:02:10, Andrew Morton wrote:
> > On Wed, 23 Jan 2008 19:47:52 +0100 Jan Kara <jack@suse.cz> wrote:
> > Implement dmode option for iso9660 filesystem to allow setting of access
> > rights for directories on the filesystem.
> 
> Please update Documentation/filesystems/isofs.txt?
  Thanks for reminding me that. The patch is below.

> Also, the usual form for the description of this patch would be
> 
> 	isofs: implement dmode option
> 
> ie: identify the subsystem first.
  Ah, OK, will do next time.

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
