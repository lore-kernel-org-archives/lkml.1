Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYGTA4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYGTA4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 20:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYGTA40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 20:56:26 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:35362 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbYGTA4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 20:56:25 -0400
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.6.4
cc: linux-kernel@vger.kernel.org
Date: Sat, 19 Jul 2008 17:56:18 -0700
Message-ID: <7vd4l9jrv1.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: AD231896-55F6-11DD-9823-3113EBD4C077-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.6.4 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.6.4.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.5.6.4.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.6.4.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are also provided
as courtesy.

  RPMS/$arch/git-*-1.5.6.4-1.fc9.$arch.rpm	(RPM)

GIT v1.5.6.4 Release Notes
==========================

Fixes since v1.5.6.3
--------------------

* Various commands could overflow its internal buffer on a platform
  with small PATH_MAX value in a repository that has contents with
  long pathnames.

* There wasn't a way to make --pretty=format:%<> specifiers to honor
  .mailmap name rewriting for authors and committers.  Now you can with
  %aN and %cN.

* Bash completion wasted too many cycles; this has been optimized to be
  usable again.

* Bash completion lost ref part when completing something like "git show
  pu:Makefile".

* "git-cvsserver" did not clean up its temporary working area after annotate
  request.

* "git-daemon" called syslog() from its signal handler, which was a
  no-no.

* "git-fetch" into an empty repository used to remind that the fetch will
   be huge by saying "no common commits", but this was an unnecessary
   noise; it is already known by the user anyway.

* "git-http-fetch" would have segfaulted when pack idx file retrieved
  from the other side was corrupt.

* "git-index-pack" used too much memory when dealing with a deep delta chain.

* "git-mailinfo" (hence "git-am") did not correctly handle in-body [PATCH]
  line to override the commit title taken from the mail Subject header.

* "git-rebase -i -p" lost parents that are not involved in the history
  being rewritten.

* "git-rm" lost track of where the index file was when GIT_DIR was
  specified as a relative path.

* "git-rev-list --quiet" was not quiet as advertised.

Contains other various documentation fixes.
