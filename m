Return-Path: <linux-kernel-owner+w=401wt.eu-S1761187AbZEMSo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbZEMSo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760574AbZEMSoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:44:17 -0400
Received: from fed1rmmtao102.cox.net ([68.230.241.44]:46411 "EHLO
	fed1rmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760373AbZEMSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:44:16 -0400
X-Authority-Analysis: v=1.0 c=1 a=VwQbUJbxAAAA:8 a=rJ2SNjQboeCICQIKKwAA:9
 a=cg30MBeRlxRWnfW0QQbfP5u0ZtAA:4
X-CM-Score: 0.00
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.3.1
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 13 May 2009 11:31:51 -0700
Message-ID: <7vy6t04zxk.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.3.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.3.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.3.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.3.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.3.1-1.fc9.$arch.rpm	(RPM)

Embarrasingly 1.6.3 has a rather grave regression when you switch to a new
branch while you have some changes added to the index.  A commit you make
from that index will record a wrong tree.  Please consider this a hotfix
and do not use vanilla 1.6.3.

----------------------------------------------------------------

Changes since v1.6.3 are as follows:

Alex Riesen (1):
      Clarify kind of conflict in merge-one-file helper

Alexander Potashev (1):
      Documentation: cloning to empty directory is allowed

Felipe Contreras (1):
      git config: clarify --add and --get-color

Junio C Hamano (4):
      Start 1.6.3.1 maintenance series.
      archive-tar.c: squelch a type mismatch warning
      Revert "checkout branch: prime cache-tree fully"
      GIT 1.6.3.1
