Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYKISH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYKISH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 13:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbYKISHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 13:07:46 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:34674 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbYKISHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 13:07:45 -0500
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.0.4
cc: linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 10:07:29 -0800
Message-ID: <7v8wrsbwny.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 4D92E528-AE89-11DD-A3C5-4F5276724C3F-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.0.4 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.0.4.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.0.4.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.0.4.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are also provided
as courtesy.

  RPMS/$arch/git-*-1.6.0.4-1.fc9.$arch.rpm	(RPM)

Fixes since v1.6.0.3
--------------------

* 'git add -p' said "No changes" when only binary files were changed.

* 'git archive' did not work correctly in bare repositories.

* 'git checkout -t -b newbranch' when you are on detached HEAD was broken.

* when we refuse to detect renames because there are too many new or
  deleted files, 'git diff' did not say how many there are.

* 'git push --mirror' tried and failed to push the stash; there is no
  point in sending it to begin with.

* 'git push' did not update the remote tracking reference if the corresponding
  ref on the remote end happened to be already up to date.

* 'git pull $there $branch:$current_branch' did not work when you were on
  a branch yet to be born.

* when giving up resolving a conflicted merge, 'git reset --hard' failed
  to remove new paths from the working tree.

* 'git send-email' had a small fd leak while scanning directory.

* 'git status' incorrectly reported a submodule directory as an untracked
  directory.

* 'git svn' used deprecated 'git-foo' form of subcommand invocaition.

* 'git update-ref -d' to remove a reference did not honor --no-deref option.

* Plugged small memleaks here and there.

* Also contains many documentation updates.
