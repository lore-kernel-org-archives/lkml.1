Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZIMKMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZIMKMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 06:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZIMKMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 06:12:16 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:39998 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZIMKMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 06:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=mp2
	gX/srxJC/OeujuJym+/RwC89PvblJzUJFzLbemCv3c42CAKYE6fyFEufCTvGlrHi
	Pj0cyJrrEl3cmXoP12H7pjDF5vEuzKRGP3zhd+QlmJiee9l1GLuRuZOUWxzSHN1O
	QLIh1QS7P24mH+PdfoOiRq/7bxyb3EP5QLuXjaho=
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.4.3
From: Junio C Hamano <gitster@pobox.com>
Date: Sun, 13 Sep 2009 03:12:02 -0700
Message-ID: <7v1vmbw3v1.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: E873C8EE-A04D-11DE-92EF-8B19076EA04E-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.4.3 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.4.3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.4.3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.4.3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.4.3-1.fc9.$arch.rpm	(RPM)


GIT v1.6.4.3 Release Notes
==========================

Fixes since v1.6.4.2
--------------------

* "git clone" from an empty repository gave unnecessary error message,
  even though it did everything else correctly.

* "git cvsserver" invoked git commands via "git-foo" style, which has long
  been deprecated.

* "git fetch" and "git clone" had an extra sanity check to verify the
  presense of the corresponding *.pack file before downloading *.idx
  file by issuing a HEAD request.  Github server however sometimes
  gave 500 (Internal server error) response to HEAD even if a GET
  request for *.pack file to the same URL would have succeeded, and broke
  clone over HTTP from some of their repositories.  As a workaround, this
  verification has been removed (as it is not absolutely necessary).

* "git grep" did not like relative pathname to refer outside the current
  directory when run from a subdirectory.

* an error message from "git push" was formatted in a very ugly way.

* "git svn" did not quote the subversion user name correctly when
  running its author-prog helper program.

Other minor documentation updates are included.
