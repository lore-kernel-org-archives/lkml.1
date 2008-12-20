Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYLTGlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYLTGlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 01:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYLTGkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 01:40:53 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:53357 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYLTGkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 01:40:52 -0500
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.0.6
cc: linux-kernel@vger.kernel.org
Date: Fri, 19 Dec 2008 22:40:41 -0800
Message-ID: <7vljub1h92.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 23A27B82-CE61-11DD-8EB0-F83E113D384A-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.0.6 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.0.6.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.0.6.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.0.6.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are also provided
as courtesy.

  RPMS/$arch/git-*-1.6.0.6-1.fc9.$arch.rpm	(RPM)

Among miscellaneous fixes, this contains a local gitweb security fix.
Maintenance releases for older versions (v1.5.4.7, v1.5.5.6 and v1.5.6.6)
are also available at the same place.

----------------------------------------------------------------

Changes since v1.6.0.5 are as follows:

David Aguilar (1):
      git-mergetool: properly handle "git mergetool -- filename"

Deskin Miller (1):
      git-svn: Make following parents atomic

Jim Meyering (1):
      git-config.txt: fix a typo

Johannes Schindelin (2):
      fast-import: close pack before unlinking it
      fast-export: deal with tag objects that do not have a tagger

Junio C Hamano (6):
      work around Python warnings from AsciiDoc
      git-show: do not segfault when showing a bad tag
      pager: do not dup2 stderr if it is already redirected
      gitweb: do not run "git diff" that is Porcelain
      GIT 1.5.4.7
      fast-import: make tagger information optional

Linus Torvalds (1):
      fsck: reduce stack footprint

Markus Heidelberg (1):
      Documentation: fix typos, grammar, asciidoc syntax

Miklos Vajna (1):
      SubmittingPatches: mention the usage of real name in Signed-off-by: lines

Nicolas Pitre (1):
      make sure packs to be replaced are closed beforehand

Wu Fengguang (1):
      git-send-email: handle email address with quoted comma

