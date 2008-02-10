Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbYBJKsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbYBJKsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYBJKsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:48:13 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:54449 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbYBJKsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:48:11 -0500
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.4.1
cc: linux-kernel@vger.kernel.org
Date: Sun, 10 Feb 2008 02:47:59 -0800
Message-ID: <7vodapgk9s.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.4.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.4.1.tar.{gz,bz2}			(tarball)
  git-htmldocs-1.5.4.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.4.1.tar.{gz,bz2}		(preformatted docs)
  RPMS/$arch/git-*-1.5.4.1-1.$arch.rpm	(RPM)

Among a handful of documentation patches, there are a few true
bugfixes.

 * An entry in the .gitattributes file that names a pattern in a
   subdirectory of the directory it is in did not match
   correctly (e.g. pattern "b/*.c" in "a/.gitattributes" should
   match "a/b/foo.c" but it didn't).

 * "git-commit -C $tag" used to work but rewrite in C done in
   1.5.4 broke it, which this release fixes.

 * Customized color specification was parsed incorrectly when
   numeric color values are used.

----------------------------------------------------------------

Changes since v1.5.4 are as follows:

Gerrit Pape (1):
      INSTALL: git-merge no longer uses cpio

Jari Aalto (1):
      Documentation/git-stash.txt: Adjust SYNOPSIS command syntax (2)

Junio C Hamano (3):
      Update stale documentation links from the main documentation.
      Fix "git-commit -C $tag"
      gitattributes: fix relative path matching

Jörg Sommer (2):
      git-am: fix type in its usage string
      git-remote documentation: fix synopsis to match description

Tim Stoakes (1):
      Fix typo in 'blame' documentation.

Timo Hirvonen (1):
      Fix parsing numeric color values

