Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYHGA2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYHGA2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYHGA2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:28:17 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:52970 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYHGA2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:28:15 -0400
From: Junio C Hamano <junio@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.6.5
cc: linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 17:28:05 -0700
Message-ID: <7v1w11mzxm.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Pobox-Relay-ID: B80B7ED6-6417-11DD-B4C9-CE28B26B55AE-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.6.5 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.6.5.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.5.6.5.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.6.5.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are also provided
as courtesy.

  RPMS/$arch/git-*-1.5.6.5-1.fc9.$arch.rpm	(RPM)

GIT v1.5.6.5 Release Notes
==========================

Fixes since v1.5.6.4
--------------------

* "git cvsimport" used to spit out "UNKNOWN LINE..." diagnostics to stdout.

* "git commit -F filename" and "git tag -F filename" run from subdirectories
  did not read the right file.

* "git init --template=" with blank "template" parameter linked files
  under root directories to .git, which was a total nonsense.  Instead, it
  means "I do not want to use anything from the template directory".

* "git diff-tree" and other diff plumbing ignored diff.renamelimit configuration
  variable when the user explicitly asked for rename detection.

* "git name-rev --name-only" did not work when "--stdin" option was in effect.

* "git show-branch" mishandled its 8th branch.

* Addition of "git update-index --ignore-submodules" that happened during
  1.5.6 cycle broke "git update-index --ignore-missing".

* "git send-email" did not parse charset from an existing Content-type:
  header properly.

Contains other various documentation fixes.

----------------------------------------------------------------

Changes since v1.5.6.4 are as follows:

Anders Melchiorsen (1):
      Documentation: fix diff.external example

Björn Steinbrink (1):
      index-pack.c: correctly initialize appended objects

Brandon Casey (1):
      t/t4202-log.sh: add newline at end of file

Ciaran McCreesh (1):
      Make git-add -i accept ranges like 7-

Jeff King (1):
      init: handle empty "template" parameter

Jim Meyering (1):
      git-cvsimport.perl: Print "UNKNOWN LINE..." on stderr, not stdout.

Johannes Schindelin (1):
      sort_in_topological_order(): avoid setting a commit flag

Jonathan Nieder (2):
      fix usage string for git grep
      git-diff(1): "--c" -> "--cc" typo fix

Junio C Hamano (12):
      refresh-index: fix bitmask assignment
      tests: propagate $(TAR) down from the toplevel Makefile
      Makefile: fix shell quoting
      make sure parsed wildcard refspec ends with slash
      Documentation: clarify diff --cc
      Update my e-mail address
      Start 1.5.6.5 RelNotes to describe accumulated fixes
      builtin-name-rev.c: split deeply nested part from the main function
      RelNotes 1.5.6.5 updates
      fix diff-tree --stdin documentation
      Files given on the command line are relative to $cwd
      GIT 1.5.6.5

Linus Torvalds (1):
      diff.renamelimit is a basic diff configuration

Mike Ralphson (1):
      Documentation: typos / spelling fixes in older RelNotes

Peter Valdemar Mørch (1):
      send-email: find body-encoding correctly

Pierre Habouzit (2):
      git-checkout: fix command line parsing.
      git-submodule: move ill placed shift.

Pieter de Bie (1):
      git-name-rev: allow --name-only in combination with --stdin

René Scharfe (1):
      git-name-rev: don't use printf without format

Stephan Beyer (1):
      builtin-revert.c: typofix

Steve Haslam (1):
      Propagate -u/--upload-pack option of "git clone" to transport.

