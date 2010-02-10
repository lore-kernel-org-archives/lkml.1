Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0BJXl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:41:27 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:64829 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab0BJXlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:41:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=FNi
	zhE+UEcWIaAVpw1L0GXEekeMixnJwYDAMmsMLzQ8aua7DC+EyJqqXG13BywzA/o4
	Hsp8HAJtSNXdmJPAzjazmgJlOseKrx5hMMKr/CZPpJBDmYM1pgxp8V3DhKYTfbpU
	JGJZIS8B17MJK/ujKJcoWS719EgNkW/Jun9JqYkE=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.6.6.2
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 10 Feb 2010 15:41:11 -0800
Message-ID: <7vvde4veug.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: C8C0FB22-169D-11DF-9E74-6AF7ED7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.6.6.2 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.6.2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.6.2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.6.2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.6.2-1.fc11.$arch.rpm	(RPM)

Git v1.6.6.2 Release Notes
==========================

Fixes since v1.6.6.1
--------------------

 * recursive merge didn't correctly diagnose its own programming errors,
   and instead caused the caller to segfault.

 * The new "smart http" aware clients probed the web servers to see if
   they support smart http, but did not fall back to dumb http transport
   correctly with some servers.

 * Time based reflog syntax e.g. "@{yesterday}" didn't diagnose a misspelled
   time specification and instead assumed "@{now}".

 * "git archive HEAD -- no-such-directory" produced an empty archive
   without complaining.

 * "git blame -L start,end -- file" misbehaved when given a start that is
   larger than the number of lines in the file.

 * "git checkout -m" didn't correctly call custom merge backend supplied
   by the end user.

 * "git config -f <file>" misbehaved when run from a subdirectory.

 * "git cvsserver" didn't like having regex metacharacters (e.g. '+') in
   CVSROOT environment.

 * "git fast-import" did not correctly handle large blobs that may
   bust the pack size limit.

 * "git gui" is supposed to work even when launched from inside a .git
   directory.

 * "git gui" misbehaved when applying a hunk that ends with deletion.

 * "git imap-send" did not honor imap.preformattedHTML as documented.

 * "git log" family incorrectly showed the commit notes unconditionally by
   mistake, which was especially irritating when running "git log --oneline".

 * "git status" shouldn't require an write access to the repository.

Other minor documentation updates are included.
