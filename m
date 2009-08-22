Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZHVHon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZHVHon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 03:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZHVHom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 03:44:42 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:50387 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbZHVHol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 03:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=EE/vFwett49D+p2Plj4
	OFPTnaVrx2GEcxC+3SL2B0eveA5J/hCL6ehiTObtsUDgcujasqScdgiiRCdb4jRT
	DCH6ZXL24+kX3yHLbkLBQwuM2Zty3zF69Jxgp+loUgc/f8tSLLHQk7RBmf2buUWp
	VtIhCuJZAoN18styEuQSrelA=
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.4.1
From: Junio C Hamano <gitster@pobox.com>
Date: Sat, 22 Aug 2009 00:44:25 -0700
Message-ID: <7vvdkg47ja.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: A4B7C6B0-8EEF-11DE-BA8A-CA0F1FFB4A78-77302942!a-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.4.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.4.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.4.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.4.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.4.1-1.fc9.$arch.rpm	(RPM)

GIT v1.6.4.1 Release Notes
==========================

Fixes since v1.6.4
------------------

 * An unquoted value in the configuration file, when it contains more than
   one whitespaces in a row, got them replaced with a single space.

 * "git am" used to accept a single piece of e-mail per file (not a mbox)
   as its input, but multiple input format support in v1.6.4 broke it.
   Apparently many people have been depending on this feature.

 * The short help text for "git filter-branch" command was a single long
   line, wrapped by terminals, and was hard to read.

 * The "recursive" strategy of "git merge" segfaulted when a merge has
   more than one merge-bases, and merging of these merge-bases involves
   a rename/rename or a rename/add conflict.

 * "git pull --rebase" did not use the right fork point when the
   repository has already fetched from the upstream that rewinds the
   branch it is based on in an earlier fetch.

 * Explain the concept of fast-forward more fully in "git push"
   documentation, and hint to refer to it from an error message when the
   command refuses an update to protect the user.

 * The default value for pack.deltacachesize, used by "git repack", is now
   256M, instead of unbounded.  Otherwise a repack of a moderately sized
   repository would needlessly eat into swap.

 * Document how "git repack" (hence "git gc") interacts with a repository
   that borrows its objects from other repositories (e.g. ones created by
   "git clone -s").

 * "git show" on an annotated tag lacked a delimiting blank line between
   the tag itself and the contents of the object it tags.

 * "git verify-pack -v" erroneously reported number of objects with too
   deep delta depths as "chain length 0" objects.

 * Long names of authors and committers outside US-ASCII were sometimes
   incorrectly shown in "gitweb".

Other minor documentation updates are included.

----------------------------------------------------------------

Changes since v1.6.4 are as follows:

Björn Steinbrink (1):
      config: Keep inner whitespace verbatim

Erik Faye-Lund (1):
      send-email: remove debug trace

Jakub Narebski (1):
      gitweb/README: Document $base_url

Jeff King (3):
      show: suppress extra newline when showing annotated tag
      show: add space between multiple items
      docs: describe impact of repack on "clone -s"

Jens Lehmann (1):
      Documentation: git submodule: add missing options to synopsis

Johan Herland (1):
      help.c: give correct structure's size to memset()

Johannes Schindelin (1):
      filter-branch: add an example how to add ACKs to a range of commits

Junio C Hamano (5):
      merge-recursive: don't segfault while handling rename clashes
      t5510: harden the way verify-pack is used
      verify-pack -v: do not report "chain length 0"
      am: allow individual e-mail files as input
      GIT 1.6.4.1

Mark A Rada (1):
      git-instaweb: fix mod_perl detection for apache2

Matthieu Moy (3):
      Better usage string for reflog.
      push: point to 'git pull' and 'git push --force' in case of non-fast forward
      filter-branch: make the usage string fit on 80 chars terminals.

Miklos Vajna (1):
      hg-to-git: don't import the unused popen2 module

Nicolas Pitre (1):
      don't let the delta cache grow unbounded in 'git repack'

Nicolas Sebrecht (1):
      git-am: print fair error message when format detection fails

Ori Avtalion (1):
      Change mentions of "git programs" to "git commands"

Paul Bolle (2):
      Documentation: merge: one <remote> is required
      Documentation: add: <filepattern>... is optional

Santi Béjar (2):
      t5520-pull: Test for rebased upstream + fetch + pull --rebase
      pull: support rebased upstream + fetch + pull --rebase

Zoltán Füzesi (1):
      gitweb: parse_commit_text encoding fix

Štěpán Němec (1):
      Fix typos in git-remote.txt and git-symbolic-ref.txt

