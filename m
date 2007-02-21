Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXBUGIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXBUGIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 01:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXBUGIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 01:08:54 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39956 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXBUGIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 01:08:53 -0500
Date: Wed, 21 Feb 2007 01:08:49 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: git@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] Guilt v0.20
Message-ID: <20070221060849.GA3856@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guilt v0.20 is available for download (once it mirrors out on kernel.org).

Guilt (Git Quilt) is a series of bash scripts which add a Mercurial
queues-like functionality and interface to git.

Tarballs:
http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/

Git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git

 
Pretty much all the changes are related to the patchbomb and import-commit
scripts. They now take a range of commits in one of these formats:

      <hash>		- one commit
      <hash>..		- hash until head (excludes hash, includes head)
      ..<hash>		- until hash (includes hash)
      <hash1>..<hash2>	- from hash to hash (inclusive)

Josef "Jeff" Sipek.

------------
Changes since v0.19:

Brandon Philips (1):
      guilt: Silence command echoing for echos in Makefile

Josef 'Jeff' Sipek (7):
      import-commit: simple commit to patch importer
      munge_hash_range: Helper function
      patchbomb: Use munge_hash_range
      import-commit: Use munge_hash_range
      patchbomb: Don't ask for the intro email if sending only one patch
      Centralize pager determining code
      Guilt v0.20
