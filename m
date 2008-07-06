Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYGFFek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYGFFek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 01:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYGFFea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 01:34:30 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:34699 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYGFFea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 01:34:30 -0400
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.6.2
cc: linux-kernel@vger.kernel.org
Date: Sat, 05 Jul 2008 22:34:15 -0700
Message-ID: <7vy74fo9t4.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Pobox-Relay-ID: 33E638D4-4B1D-11DD-9F13-CE28B26B55AE-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.6.2 are available at the usual
places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.6.2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.5.6.2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.6.2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are also provided as
courtesy.  As the machine I cut them at kernel.org has been updated to FC9
recently, their filenames now have .fc9. in them.

  RPMS/$arch/git-*-1.5.6.2-1.fc9.$arch.rpm	(RPM)

There still are a handful more fixes queued for 'maint' so we might see
another maintenance release, 1.5.6.3, not too far in the future.

----------------------------------------------------------------

Changes since v1.5.6.1 are as follows:

Avery Pennarun (1):
      git-svn: avoid filling up the disk with temp files.

Björn Steinbrink (1):
      git cat-file: Fix memory leak in batch mode

Eric Wong (1):
      git-svn: don't sanitize remote names in config

Jeff King (3):
      fetch: report local storage errors in status table
      doc/rev-parse: clarify reflog vs --until for specifying revisions
      fetch: give a hint to the user when local refs fail to update

Jochen Voss (1):
      avoid off-by-one error in run_upload_archive

Joey Hess (1):
      fix git config example syntax

Johannes Schindelin (2):
      clone: respect url.insteadOf setting in global configs
      clone: respect the settings in $HOME/.gitconfig and /etc/gitconfig

Junio C Hamano (9):
      Allow "git-reset path" when unambiguous
      diff --check: do not discard error status upon seeing a good line
      git-shell: accept "git foo" form
      GIT 1.5.4.6
      GIT 1.5.5.5
      Start draft release notes for 1.5.6.2
      Work around gcc warnings from curl headers
      Fix executable bits in t/ scripts
      GIT 1.5.6.2

Shawn O. Pearce (1):
      Fix describe --tags --long so it does not segfault

Thomas Rast (1):
      Fix 'git show' on signed tag of signed tag of commit

