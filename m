Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbXBYR6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbXBYR6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbXBYR6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:58:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:42082 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbXBYR6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AnGQ/hWyQnLRz5CxUBmZIxlKIRNJx+3SgfYs3FQinkZALjR9R+O5onQeUb11+n3LKUxc6CcztBYB0S1J9a0Ogz8E7w84iDrlgYidOjrcjqqbEHeNGCYSTeMGUsNq1t9zSAaIJ+hdRW5x0dePxNtYjpXcG3bsHdoBip9JaUpSotQ=
Message-ID: <e5bfff550702250958n6cddc5b5lec4badf1f7fc8231@mail.gmail.com>
Date: Sun, 25 Feb 2007 18:58:12 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: "Git Mailing List" <git@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] qgit-1.5.5
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

qgit is a git repository GUI browser. This is mostly a bug fix release.

Due to a change in git-rev-list output in git version 1.5 and above in
case of commit encoding information old version of qgit are no more
compatible and big issues in revision list view are possible under
some circumstances.

So an upgrade to this release is strongly suggested for all the users
of new version of git (1.5 and above).

Download tarball from http://www.sourceforge.net/projects/qgit or
directly from git public repository
git://git.kernel.org/pub/scm/qgit/qgit.git

Please refer to http://digilander.libero.it/mcostalba/ for additional
information.

	Marco

P.S: There is also a Qt4 version (works under Windows) downloadable
from git://repo.or.cz/qgit4.git  it is a little bit experimental
tough.



ChangeLog from 1.5.4

- fix a spurious double popup menu in rare cases

- add support to show user info in Edit->Settings->Commit

- file names cache optimization: reduce load time by 35% and memory by 30%

- fix opening a repo from a read-only filesystem

- filter out StGIT bases in our tag list

- use light orange for remote branches (Pavel Roskin)

- add 'Remote branches' context sub menu

- fix disappearing merge files list when browsing revs

- delay cache loading a little bit and fix a bug

- fix a parsing error in case of combined merges

- support new git text encoding policy in log messages

- fix a subtle bug that could lead to miss an update event

- fix bug in revisions loading sequence numbers

- fix parsing in case of revision headers with extended information

- fix stripping of comments in commit dialog message
