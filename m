Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZCPEwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZCPEwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZCPEwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:52:32 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:40447 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZCPEwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:52:31 -0400
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.2.1
Date: Sun, 15 Mar 2009 21:52:22 -0700
Message-ID: <7vwsaqysqh.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 40FB9088-11E6-11DE-8F76-C5D912508E2D-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.2.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.2.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.2.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.2.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS//git-*-1.6.2.1-1.fc9.$arch.rpm	(RPM)

----------------------------------------------------------------

GIT v1.6.2.1 Release Notes
==========================

Fixes since v1.6.2
------------------

* .gitignore learned to handle backslash as a quoting mechanism for
  comment introduction character "#".

* timestamp output in --date=relative mode used to display timestamps that
  are long time ago in the default mode; it now uses "N years M months
  ago", and "N years ago".

* git-add -i/-p now works with non-ASCII pathnames.

* "git hash-object -w" did not read from the configuration file from the
  correct .git directory.

* git-send-email learned to correctly handle multiple Cc: addresses.
