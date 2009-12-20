Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbZLTXAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbZLTXAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 18:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZLTXAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 18:00:01 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:51328 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbZLTXAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 18:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=Ld++2RGc0r3ZhKrBtzB
	OxOcVdOQOlV7te5RBOMURtsRTdZj1J8pGyWo+ZHqYxCixDOdQnBEz8AsicWLKgjf
	2HZgxbBqpq2sbAvtmP7eeXQdvtuVFsbWKKvazy6VniPOAju9un7+2tet4ClgZrjc
	Gs3ilJYvaBuPPCvv1yQz8NxM=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.6.6.rc4
From: Junio C Hamano <gitster@pobox.com>
Date: Sun, 20 Dec 2009 14:59:47 -0800
Message-ID: <7vmy1d9rq4.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 62804BF2-EDBB-11DE-A875-DC0DEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.6.6.rc4 is available at the usual places
for final testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.6.rc4.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.6.rc4.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.6.rc4.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.6.6.rc4-1.fc11.$arch.rpm	(RPM)

Hopefully I'll do the final this Wednesday to make 1.6.6 a holiday gift to
everybody.

I would very much prefer news outlets like kernelpodcast.org and lwn.net
_not_ to say "... is released; it comes with many _fixes_".  Fixes to
released versions have indeed been included in the 'master' branch, but
they all appear in the maintenance release.  The main _point_ of using a
new feature release like 1.6.6 is to get new _features_, so it is more
appropriate to say "it comes with many new features."

Thanks for all contributors who have worked hard to whip this release into
shape.

----------------------------------------------------------------

Changes since v1.6.6-rc3 are as follows:

Björn Gustavsson (1):
      rebase -i: abort cleanly if the editor fails to launch

Eric Wong (2):
      git svn: make empty directory creation gc-aware
      t9146: use 'svn_cmd' wrapper

Junio C Hamano (1):
      Git 1.6.6-rc4

Stephen Boyd (2):
      api-strbuf.txt: fix typos and document launch_editor()
      technical-docs: document hash API

