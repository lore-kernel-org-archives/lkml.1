Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYFZGWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYFZGWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYFZGV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:21:56 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:65507 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYFZGVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:21:55 -0400
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.6.1
References: <7vmylixr6h.fsf@gitster.siamese.dyndns.org>
cc: linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2008 23:21:36 -0700
In-Reply-To: <7vmylixr6h.fsf@gitster.siamese.dyndns.org> (Junio C. Hamano's
 message of "Wed, 18 Jun 2008 16:24:22 -0700")
Message-ID: <7v3an0u367.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Pobox-Relay-ID: 2AE5D60E-4348-11DD-84A6-CE28B26B55AE-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.6.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.6.1.tar.{gz,bz2}			(tarball)
  git-htmldocs-1.5.6.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.6.1.tar.{gz,bz2}		(preformatted docs)
  RPMS/$arch/git-*-1.5.6.1-1.$arch.rpm	(RPM)

GIT v1.5.6.1 Release Notes
==========================

Fixes since v1.5.6
------------------

* Last minute change broke loose object creation on AIX.

* (performance fix) We used to make $GIT_DIR absolute path early in the
  programs but keeping it relative to the current directory internally
  gives 1-3 per-cent performance boost.

* bash completion knows the new --graph option to git-log family.


* git-diff -c/--cc showed unnecessary "deletion" lines at the context
  boundary.

* git-for-each-ref ignored %(object) and %(type) requests for tag
  objects.

* git-merge usage had a typo.

* Rebuilding of git-svn metainfo database did not take rewriteRoot
  option into account.

* Running "git-rebase --continue/--skip/--abort" before starting a
  rebase gave nonsense error messages.

----------------------------------------------------------------

Changes since v1.5.6 are as follows:

Brandon Casey (2):
      git-merge.sh: fix typo in usage message: sucesses --> succeeds
      t7502-commit.sh: test_must_fail doesn't work with inline environment variables

Dan McGee (1):
      completion: add --graph to log command completion

Dmitry Potapov (1):
      fix update-hook-example to work with packed tag references

Jan Krüger (2):
      Documentation: fix formatting in git-svn
      git-svn: make rebuild respect rewriteRoot option

Jeff King (2):
      for-each-ref: implement missing tag values
      clone: create intermediate directories of destination repo

Junio C Hamano (2):
      diff -c/--cc: do not include uninteresting deletion before leading context
      GIT 1.5.6.1

Linus Torvalds (1):
      Make git_dir a path relative to work_tree in setup_work_tree()

Michele Ballabio (1):
      parse-options.c: fix documentation syntax of optional arguments

Patrick Higgins (1):
      Workaround for AIX mkstemp()

Stephan Beyer (4):
      git-rebase.sh: Add check if rebase is in progress
      api-builtin.txt: update and fix typo
      api-parse-options.txt: Introduce documentation for parse options API
      Extend parse-options test suite

