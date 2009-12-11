Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZLKGJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZLKGJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbZLKGJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:09:21 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:58517 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbZLKGJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:09:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=c7W6ngFHrJPKV3UNqUx
	DRtKLTOjGyhzijlGflY9CS8AZCZWQfFcYCZiLGNgV1OXguxget78vkXZQl7RVCRB
	OdUiCNi6xlyQbBKbBwrLAe3DAMvLqy6qdFW2m9HOkcguTQsQ45BnRCKUmnTgrZor
	JaaS1Y2p7Gt1l5d5YFCncskE=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.6.5.6
From: Junio C Hamano <gitster@pobox.com>
Date: Thu, 10 Dec 2009 22:09:12 -0800
Message-ID: <7vljha59fb.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: B88F0544-E61B-11DE-8D99-B34DBBB5EC2E-77302942!a-pb-sasl-sd.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.6.5.6 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.5.6.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.5.6.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.5.6.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.5.6-1.fc11.$arch.rpm	(RPM)

Hopefully this will be the last update to the 1.6.5.X series before the
upcoming feature release (1.6.6).  It fixes a security issue, and users of
older 1.6.5.X series are strongly recommended to update to this version.

Git v1.6.5.6 Release Notes
==========================

Fixes since v1.6.5.5
--------------------

 * "git add -p" had a regression since v1.6.5.3 that broke deletion of
   non-empty files.

 * "git archive -o o.zip -- Makefile" produced an archive in o.zip
   but in POSIX tar format.

 * Error message given to "git pull --rebase" when the user didn't give
   enough clue as to what branch to integrate with still talked about
   "merging with" the branch.

 * Error messages given by "git merge" when the merge resulted in a
   fast-forward still were in plumbing lingo, even though in v1.6.5
   we reworded messages in other cases.

 * The post-upload-hook run by upload-pack in response to "git fetch" has
   been removed, due to security concerns (the hook first appeared in
   1.6.5).

----------------------------------------------------------------

Changes since v1.6.5.5 are as follows:

Jan Krüger (1):
      pull: clarify advice for the unconfigured error case

Jeff King (1):
      add-interactive: fix deletion of non-empty files

Junio C Hamano (3):
      Remove post-upload-hook
      Fix archive format with -- on the command line
      Git 1.6.5.6

Matthieu Moy (2):
      merge-recursive: make the error-message generation an extern function
      builtin-merge: show user-friendly error messages for fast-forward too.

