Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYLOIc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYLOIc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYLOIcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:32:45 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:64525 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbYLOIco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:32:44 -0500
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.1-rc3
References: <7vbpvnbcoa.fsf@gitster.siamese.dyndns.org>
cc: linux-kernel@vger.kernel.org
Date: Mon, 15 Dec 2008 00:32:36 -0800
In-Reply-To: <7vbpvnbcoa.fsf@gitster.siamese.dyndns.org> (Junio C. Hamano's
 message of "Sun, 07 Dec 2008 18:53:09 -0800")
Message-ID: <7voczdyh23.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: F12E7A66-CA82-11DD-9E1E-F83E113D384A-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have fixed a few more smallish (old) bugs after I tagged this, which
will be in 'master' shortly, but it seems that this cycle is stabilizing
fairly nicely.  Let's have a successful 1.6.1 tagged on 20th.  Please hunt
and fix bugs until then.

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.1-rc3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.1-rc3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.1-rc3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are also there.

  testing/git-*-1.6.1-rc3-1.fc9.$arch.rpm	(RPM)

----------------------------------------------------------------

Changes since v1.6.1-rc2 are as follows:

Alexander Gavrilov (1):
      Documentation: Describe git-gui Tools menu configuration options.

Alexander Potashev (2):
      Fix typos in documentation
      Fix typo in comment in builtin-add.c

Alexey Borzenkov (1):
      Define linkgit macro in [macros] section

Brandon Casey (1):
      git-branch: display sha1 on branch deletion

Deskin Miller (1):
      git-svn: Make following parents atomic

Jakub Narebski (1):
      gitweb: Fix bug in insert_file() subroutine

Jeff King (5):
      reorder ALLOW_TEXTCONV option setting
      diff: allow turning on textconv explicitly for plumbing
      diff: fix handling of binary rewrite diffs
      diff: respect textconv in rewrite diffs
      rebase: improve error messages about dirty state

Jim Meyering (1):
      git-config.txt: fix a typo

Johannes Schindelin (1):
      Get rid of the last remnants of GIT_CONFIG_LOCAL

Junio C Hamano (4):
      builtin-checkout.c: check error return from read_cache()
      read-cache.c: typofix in comment
      work around Python warnings from AsciiDoc
      Fix t4031

Linus Torvalds (1):
      fsck: reduce stack footprint

Markus Heidelberg (1):
      builtin-commit: remove unused message variable

Nicolas Pitre (1):
      make sure packs to be replaced are closed beforehand

Ralf Wildenhues (1):
      Improve language in git-merge.txt and related docs

Tor Arvid Lund (1):
      git-p4: Fix regression in p4Where method.

YONETANI Tomokazu (1):
      git-fast-import possible memory corruption problem

