Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbZIPX05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbZIPX05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760398AbZIPX0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:26:55 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:50153 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbZIPX0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=EfQ
	n4H9ftCd5ZwrZbN55kgVfZ2Yw8fQXoJT3TcuQkHhQ+MbqmpFfwtnTsp5VXmHg7C5
	WOHFBmCnWM7ocBb0U9Lb7AP+1VBdmxd/hNnKewL5ikgshDwlCl4G7eCkwXF0C5Ha
	CAJHjPy4T3oy8f1ngZE7iF8MoyFqQgqok2m77Zm4=
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.4.4
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 16 Sep 2009 16:26:42 -0700
Message-ID: <7v4or2wjwt.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 6AF82356-A318-11DE-8152-8B19076EA04E-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The latest maintenance release GIT 1.6.4.4 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.4.4.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.4.4.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.4.4.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.4.4-1.fc9.$arch.rpm	(RPM)

This is primarily to fix a http regression introduced by 1.6.4.3

GIT v1.6.4.4 Release Notes
==========================

Fixes since v1.6.4.4
--------------------

* The workaround for Github server that sometimes gave 500 (Internal server
  error) response to HEAD requests in 1.6.4.3 introduced a regression that
  caused re-fetching projects over http to segfault in certain cases due
  to uninitialized pointer being freed.

* "git pull" on an unborn branch used to consider anything in the work
  tree and the index discardable.

* "git diff -b/w" did not work well on the incomplete line at the end of
  the file, due to an incorrect hashing of lines in the low-level xdiff
  routines.

* "git checkout-index --prefix=$somewhere" used to work when $somewhere is
  a symbolic link to a directory elsewhere, but v1.6.4.2 broke it.

* "git unpack-objects --strict", invoked when receive.fsckobjects
  configuration is set in the receiving repository of "git push", did not
  properly check the objects, especially the submodule links, it received.

Other minor documentation updates are included.
