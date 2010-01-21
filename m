Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062Ab0AUAvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab0AUAvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294Ab0AUAvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:51:53 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:58930 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0AUAvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=BL/
	0R1gVpUenc8/P1XQsUnuCFOIxvS7pihnPmnHnNy45Taze0V5SXaNySns70sBWINE
	wfg0E72n2WFOZcXCog/vWy64eU9FnO/WfZOE+HCn+YDqmSAYeDzHHaAZ9IqPxwSF
	DJOV2Mhvzisry03dUNisZM8OmPMpL/f/OsR2fk/M=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.6.6.1
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 20 Jan 2010 16:51:41 -0800
Message-ID: <7vpr54xote.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 271A1C8A-0627-11DF-B146-6AF7ED7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.6.6.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.6.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.6.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.6.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.6.1-1.fc11.$arch.rpm	(RPM)

Git v1.6.6.1 Release Notes
==========================

Fixes since v1.6.6
------------------

 * "git blame" did not work well when commit lacked the author name.

 * "git branch -a name" wasn't diagnosed as an error.

 * "git count-objects" did not handle packfiles that are bigger than 4G on
   platforms with 32-bit off_t.

 * "git checkout -m other" while on a branch that does not have any commit
   segfaulted, instead of failing.

 * "git fast-import" choked when fed a tag that do not point at a
   commit.

 * "git grep" finding from work tree files could have fed garbage to
   the underlying regexec(3).

 * "git grep -L" didn't show empty files (they should never match, and
   they should always appear in -L output as unmatching).

 * "git rebase -i" did not abort cleanly if it failed to launch the editor.

 * "git reset --hard" did not work correctly when GIT_WORK_TREE environment
   variable is used to point at the root of the true work tree.

 * http-backend was not listed in the command list in the documentation.

 * Building on FreeBSD (both 7 and 8) needs OLD_ICONV set in the Makefile

 * "git checkout -m some-branch" while on an unborn branch crashed.

Other minor documentation updates are included.
