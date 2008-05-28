Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbYE1ITV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbYE1ITV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYE1ITH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:19:07 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:47688 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYE1ITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:19:05 -0400
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.5.3
References: <7viqx1g8ix.fsf@gitster.siamese.dyndns.org>
cc: linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 01:18:55 -0700
In-Reply-To: <7viqx1g8ix.fsf@gitster.siamese.dyndns.org> (Junio C. Hamano's
 message of "Sun, 25 May 2008 18:26:46 -0700")
Message-ID: <7vlk1ux2mo.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: BA97515E-2C8E-11DD-A9F7-80001473D85F-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.5.3 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.5.3.tar.{gz,bz2}			(tarball)
  git-htmldocs-1.5.5.3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.5.3.tar.{gz,bz2}		(preformatted docs)
  RPMS/$arch/git-*-1.5.5.3-1.$arch.rpm	(RPM)

This one is much smaller than 1.5.5.2, primarily to push out a few fixes
to send-email and bisect that have already been in 'master' for a while.

----------------------------------------------------------------

Changes since v1.5.5.2 are as follows:

Christian Couder (1):
      bisect: print an error message when "git rev-list --bisect-vars" fails

Gerrit Pape (3):
      git-bisect.sh: don't accidentally override existing branch "bisect"
      Documentation/git-bundle.txt: fix synopsis
      commit --interactive: properly update the index before commiting

Horst H. von Brand (1):
      Fix recipient santitization

Jeff King (2):
      send-email: specify content-type of --compose body
      send-email: rfc2047-quote subject lines with non-ascii characters

Johannes Sixt (1):
      Revert "filter-branch: subdirectory filter needs --full-history"

Junio C Hamano (3):
      Release Notes for 1.5.5.2
      show-branch --current: do not barf on detached HEAD
      GIT 1.5.5.3

Lea Wiemann (1):
      gitweb: only display "next" links in logs if there is a next page

Michele Ballabio (1):
      Documentation: fix graph in git-rev-parse.txt

Pieter de Bie (1):
      builtin-fast-export: Only output a single parent per line

