Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXBLTsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXBLTsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965352AbXBLTsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:48:20 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37801 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbXBLTsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:48:19 -0500
Date: Mon, 12 Feb 2007 14:48:17 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: git@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] Guilt v0.19
Message-ID: <20070212194816.GB12616@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guilt v0.19 is available for download (once it mirrors out on kernel.org).

Guilt (Git Quilt) is a series of bash scripts which add a Mercurial
queues-like functionality and interface to git.

Tarballs:
http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/

Git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git


The most important change is the use of the patch file's mtime as the
GIT_{AUTHOR,COMMITTER}_DATE. Without this change, repeated invocations of
"guilt pop -a; guilt push -a" would create new commit's with different
commit dates, creating a lot of garbage commits. Other changes are mostly
related to expanding (and slightly fixing) the regression scripts.

Josef "Jeff" Sipek.

------------

Changes since v0.18:

Josef 'Jeff' Sipek (18):
      guilt-applied: added -c to list the commit hash for the patch
      guilt-new: Fix [ syntax
      patchbomb: Friendly wrapper for git-format-patch & git-send-email
      delete: Added argument -f to remove patch file
      Guilt v0.19-rc1
      regression: test new patch insertion
      regression: test new patch insertion at the end
      regression: Test push/pop given a patch name
      regression: Test for guilt-init in a already initialized branch
      regression: Test guilt-init on non-master branch
      regression: Fix test descriptions
      Centralize editor determining code
      new: added -e to edit the patch description interactively
      Makefile: Forgot to add guilt-patchbomb to the list of scripts
      regression: Fix regression test failure
      patchbomb: Added -n flag
      regression: Fixed regression suite failure
      Guilt v0.19

Theodore Ts'o (1):
      Use patch file's modtime as the git author and commiter date
