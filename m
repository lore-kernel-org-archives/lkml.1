Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbZH3Gak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbZH3Gak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 02:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZH3Gaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 02:30:39 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:58564 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbZH3Gai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 02:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=DyN
	qnI3m4uw8J/mDIwyE1XYFsEo+xVbSEMNmvoEc1pl/BvcJH2SGQJ78XsuPS8mB5je
	OEY9BQNztixQYNGMr3vEQY09oViz68tRI+miMEmRDVRM7DCUQiAydDVTQXJAeRW+
	3OXniX+aj1ztkom5E++3vd/6xhZZaFyrgUlpZssc=
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.4.2
From: Junio C Hamano <gitster@pobox.com>
Date: Sat, 29 Aug 2009 23:30:25 -0700
Message-ID: <7v1vmtreym.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: A00CEC90-952E-11DE-9CFA-8B19076EA04E-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.4.2 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.4.2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.4.2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.4.2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.4.2-1.fc9.$arch.rpm	(RPM)

GIT v1.6.4.2 Release Notes
==========================

Fixes since v1.6.4.1
--------------------

* --date=relative output between 1 and 5 years ago rounded the number of
    years when saying X years Y months ago, instead of rounding it down.

* "git add -p" did not handle changes in executable bits correctly
  (a regression around 1.6.3).

* "git apply" did not honor GNU diff's convention to mark the creation/deletion
  event with UNIX epoch timestamp on missing side.

* "git checkout" incorrectly removed files in a directory pointed by a
  symbolic link during a branch switch that replaces a directory with
  a symbolic link.

* "git clean -d -f" happily descended into a subdirectory that is managed by a
  separate git repository.  It now requires two -f options for safety.

* "git fetch/push" over http transports had two rather grave bugs.

* "git format-patch --cover-letter" did not prepare the cover letter file
  for use with non-ASCII strings when there are the series contributors with
  non-ASCII names.

* "git pull origin branch" and "git fetch origin && git merge origin/branch"
  left different merge messages in the resulting commit.

Other minor documentation updates are included.
