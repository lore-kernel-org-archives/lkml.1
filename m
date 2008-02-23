Return-Path: <linux-kernel-owner+w=401wt.eu-S1763696AbYBWVHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763696AbYBWVHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 16:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbYBWVHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 16:07:40 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:41581 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbYBWVHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 16:07:39 -0500
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.4.3
cc: linux-kernel@vger.kernel.org
Date: Sat, 23 Feb 2008 13:07:24 -0800
Message-ID: <7vr6f31iwj.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.4.3 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.4.3.tar.{gz,bz2}			(tarball)
  git-htmldocs-1.5.4.3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.4.3.tar.{gz,bz2}		(preformatted docs)
  RPMS/$arch/git-*-1.5.4.3-1.$arch.rpm	(RPM)

Largest user visible change in this is RPM packaging updates by
Kristian Høgsberg.  'git-core' will only be pure git without
pulling foreign SCM packages in as its dependencies anymore when
you do "yum install git-core".

----------------------------------------------------------------

GIT v1.5.4.3 Release Notes
==========================

Fixes since v1.5.4.2
--------------------

 * RPM spec used to pull in everything with 'git'.  This has been
   changed so that 'git' package contains just the core parts,
   and we now supply 'git-all' metapackage to slurp in everything.
   This should match end user's expectation better.

 * When some refs failed to update, git-push reported "failure"
   which was unclear if some other refs were updated or all of
   them failed atomically (the answer is the former).  Reworded
   the message to clarify this.

 * "git clone" from a repository whose HEAD was misconfigured
   did not set up the remote properly.  Now it tries to do
   better.

 * Updated git-push documentation to clarify what "matching"
   means, in order to reduce user confusion.

 * Updated git-add documentation to clarify "add -u" operates in
   the current subdirectory you are in, just like other commands.

 * git-gui updates to work on OSX and Windows better.

----------------------------------------------------------------

Changes since v1.5.4.2 are as follows:

Gerrit Pape (1):
      git-clone.sh: properly configure remote even if remote's head is dangling

Jay Soffian (2):
      git-gui: support Git Gui.app under OS X 10.5
      send-email: squelch warning due to comparing undefined $_ to ""

Jeff King (4):
      push: indicate partialness of error message
      Documentation/push: clarify matching refspec behavior
      push: document the status output
      hash: fix lookup_hash semantics

Junio C Hamano (1):
      GIT 1.5.4.3

Kristian H淡gsberg (1):
      Rename git-core rpm to just git and rename the meta-pacakge to git-all.

Miklos Vajna (1):
      Documentation/git-stash: document options for git stash list

Pekka Kaitaniemi (1):
      Clarified the meaning of git-add -u in the documentation

Shawn O. Pearce (5):
      git-gui: Ensure error dialogs always appear over all other windows
      git-gui: Paper bag fix error dialogs opening over the main window
      git-gui: Default TCL_PATH to same location as TCLTK_PATH
      git-gui: Avoid hardcoded Windows paths in Cygwin package files
      git-gui: Focus insertion point at end of strings in repository chooser

Wincent Colaiuta (1):
      git-gui: relax "dirty" version detection

