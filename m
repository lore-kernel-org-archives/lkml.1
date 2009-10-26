Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZJZFTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZJZFTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZJZFTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:19:35 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:50687 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZJZFTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:19:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=e+R
	WYs32JZUvA6ToR9Uu9FaXSGmD2EYzj8WaU17GT75hMA/l3iU1b6gma1QJCFRJois
	I1ZlD0Evz2UmAlRegZA4aWKUMHE0dUmBoZHszXyuXYfcHmntl2NVLzTcEa9W27a4
	BaxEkZM5zSTf6GsrnL+kSphudTGk4pFkHyCoPnb8=
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.5.2
From: Junio C Hamano <gitster@pobox.com>
Date: Sun, 25 Oct 2009 22:19:27 -0700
Message-ID: <7vljiypw9s.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 25CB2ADA-C1EF-11DE-A55F-1B12EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.5.2 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.5.2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.5.2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.5.2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.5.2-1.fc9.$arch.rpm	(RPM)

GIT v1.6.5.2 Release Notes
==========================

Fixes since v1.6.5.1
--------------------

 * Installation of templates triggered a bug in busybox when using tar
   implementation from it.

 * "git add -i" incorrectly ignored paths that are already in the index
   if they matched .gitignore patterns.

 * "git describe --always" should have produced some output even there
   were no tags in the repository, but it didn't.

 * "git ls-files" when showing tracked files incorrectly paid attention
   to the exclude patterns.

Other minor documentation updates are included.

----------------------------------------------------------------

Changes since v1.6.5.1 are as follows:

Andreas Schwab (1):
      Work around option parsing bug in the busybox tar implementation

Carlos R. Mafra (1):
      Makefile: clean block-sha1/ directory instead of mozilla-sha1/

Jeff King (2):
      ls-files: excludes should not impact tracked files
      document push's new quiet option

Joe Perches (1):
      git-send-email.perl: fold multiple entry "Cc:" and multiple single line "RCPT TO:"s

Johannes Sixt (2):
      Remove a left-over file from t/t5100
      Mark files in t/t5100 as UTF-8

Jonathan Nieder (1):
      Documentation: describe check-ref-format --branch

Junio C Hamano (4):
      Fix incorrect error check while reading deflated pack data
      Do not fail "describe --always" in a tag-less repository
      Fix list of released versions in the toc document
      GIT 1.6.5.2

Markus Heidelberg (1):
      t7800-difftool: fix the effectless GIT_DIFFTOOL_PROMPT test

Matt Kraai (1):
      Documentation/git-gc.txt: change "references" to "reference"

Nanako Shiraishi (2):
      git push: remove incomplete options list from help text
      git push: say that --tag can't be used with --all or --mirror in help text

Nasser Grainawi (1):
      Document `delta` attribute in "git help attributes".

Pauli Virtanen (1):
      git-add--interactive: never skip files included in index

