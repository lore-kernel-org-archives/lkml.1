Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbZJRBFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbZJRBFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 21:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZJRBFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 21:05:07 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:63978 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbZJRBFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 21:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=NwXl9rbRV1JifMGiBHw
	BOhwWvf7UO/X4mkW/cxMNSvpw9dpaQ3mHfESVjqG9FBIghURuJOfxDeHeTblcAs9
	tls9j8c5fs69tlU/p0KXJzSx1WiNjXRtOngANzPm2RumkLB/BhlDq5m8BUizThwn
	IZAeCmV9SB1aswvEcIRKf/Wg=
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.5.1
From: Junio C Hamano <gitster@pobox.com>
Date: Sat, 17 Oct 2009 18:04:56 -0700
Message-ID: <7vws2t5x6v.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 44F912BE-BB82-11DE-8202-A67CBBB5EC2E-77302942!a-pb-sasl-sd.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.5.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.5.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.5.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.5.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.5.1-1.fc9.$arch.rpm	(RPM)

GIT v1.6.5.1 Release Notes
==========================

Fixes since v1.6.5
------------------

 * An corrupt pack could make codepath to read objects into an
   infinite loop.

 * Download throughput display was always shown in KiB/s but on fast links
   it is more appropriate to show it in MiB/s.

 * "git grep -f filename" used uninitialized variable and segfaulted.

 * "git clone -b branch" gave a wrong commit object name to post-checkout
   hook.

 * "git pull" over http did not work on msys.

Other minor documentation updates are included.

----------------------------------------------------------------

Changes since v1.6.5 are as follows:

Björn Steinbrink (1):
      clone: Supply the right commit hash to post-checkout when -b is used

Johannes Sixt (1):
      remote-curl: add missing initialization of argv0_path

Junio C Hamano (1):
      GIT 1.6.5.1

Matt Kraai (1):
      grep: do not segfault when -f is used

Miklos Vajna (1):
      git-stash documentation: mention default options for 'list'

Nicolas Pitre (1):
      change throughput display units with fast links

Shawn O. Pearce (1):
      sha1_file: Fix infinite loop when pack is corrupted

