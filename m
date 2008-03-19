Return-Path: <linux-kernel-owner+w=401wt.eu-S935429AbYCSUyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935429AbYCSUyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbYCSTtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:49:10 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34756 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbYCSTtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:49:08 -0400
Date: Wed, 19 Mar 2008 01:29:32 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: guilt@josefsipek.net
Cc: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: [ANNOUNCE] Guilt v0.29
Message-ID: <20080319052932.GC11349@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guilt v0.29 is available for download (once it mirrors out on kernel.org).

Guilt (Git Quilt) is a series of bash scripts which add a Mercurial
queues-like functionality and interface to git.

Tarballs:
http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/

Git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git


This release is quite uneventful.  It is made up of a few fixes here and
there, and complete regression suite rewrite.  Unfortunately, most of the
exciting Guilt development went on in a topic branch, but the changes are
far too invasive for me to include them in v0.29, so I'm going to merge that
in for v0.30.

As always, patches, and other feedback is welcome.

Josef "Jeff" Sipek.

------------
Changes since v0.28:

Josef 'Jeff' Sipek (20):
      repair: new command to repair repository state
      patchbomb: Git parses the patch mboxes and extracts Cc lines automatically
      push: fix whitespace handling
      regression: rewrote regression suite core
      regression: test 010: test the init code
      regression: test 011: test failure of commands on non-init'd repo
      regression: test 020: test push code
      regression: test 023: test top code
      regression: test 021: test pop code
      regression: test 060: test files code
      regression: test 022: test applied code
      regression: test 024: test unapplied code
      regression: test 025: test new code
      regression: test 026: test delete code
      regression: test 027: test refresh code
      push: output current patch name, not cmd-line argument
      Use 'git <cmd>' instead of 'git-cmd'
      header: fix patch name existence in the series
      regression: add tests for guilt-header
      Guilt v0.29
