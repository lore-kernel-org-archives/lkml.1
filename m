Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbXKMLY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbXKMLY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXKMLYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:24:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbXKMLYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:24:48 -0500
Date: Tue, 13 Nov 2007 12:24:45 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng 2.13.1-rc1
Message-ID: <20071113112445.GB22480@petra.dvoda.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



 The first util-linux-ng 2.13.1 release candidate is available at

    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/

 (Note, 2.13.1 is stable maintenance release.)

 Feedback and bug reports, as always, are welcomed.

	Karel


Util-linux-ng 2.13.1 Release Notes
==================================

Fixed security issues:
---------------------

 CVE-2007-5191 - mount(8) doesn't drop privileges properly when
                 calling helpers

Changelog:
---------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.13/


blockdev:
   - add missing description about option --report in manpage  [Li Zefan]
build-sys:
   - fix localedir (unsupported by autoconf < 2.60)  [Karel Zak]
   - nls/locale handling in util-linux-ng general  [Mike Frysinger]
   - remove files that are no longer delivered from git  [LaMont Jones]
cal:
   - add description about option -V to manpage  [Li Zefan]
chfn:
   - add pam_end() call and cleanup PAM code  [Karel Zak]
chsh:
   - should use pam_end function to terminate the PAM transaction
     [Yu Zhiguo, Karel Zak]
docs:
   - add info about .bugfix releases and branches  [Karel Zak]
   - fix ChangeLog URL  [Pascal Terjan]
   - fix stable branche name in README.devel  [Karel Zak]
   - update AUTHORS file  [Karel Zak]
fdisk:
   - fix typo  [Karel Zak]
flock:
   - typo in man page  [A. Costa]
hwclock:
   - fix --rtc option  [Matthias Koenig, Karel Zak]
ionice:
   - add a note about permissions to ionice.1  [Karel Zak]
login:
   - login segfaults on EOF (rh#298461)  [Karel Zak]
losetup:
   - fix errno usage  [Karel Zak]
mkswap:
   - possible to crash with SELinux relabeling support  [KaiGai Kohei]
mount:
   - -L|-U segfault when label or uuid doesn't exist  [Karel Zak]
   - chain of symlinks to fstab causes use of pointer after free
     [Norbert Buchmuller]
   - doesn't drop privileges properly when calling helpers  [Ludwig Nussel]
   - improve error message when helper program not present  [LaMont Jones]
pg:
   - fix segfault on search  [Rajeev V. Pillai]
po:
   - fix typo in de.po  [Karel Zak]
   - update de.po (from translationproject.org)  [Michael Piefel]
   - update fi.po (from translationproject.org)  [Lauri Nurmi]
   - update hu.po (from translationproject.org)  [Gabor Kelemen]
   - update nl.po (from translationproject.org)  [Benno Schulenberg]
   - update po files  [Karel Zak]
   - update sv.po (from translationproject.org)  [Daniel Nylander]
rename:
   - add description about option -V to manpage  [Li Zefan]
   - remove useless variable  [Li Zefan]
script:
   - dies on SIGWINCH  [Karel Zak]
setarch:
   - adding groff symlinks to setarch manual page  [Arkadiusz Miskiewicz]
   - fix compiler warning  [LaMont Jones]
   - generate groff links in a better way  [Karel Zak]
tests:
   - fix blkid cache usage  [Karel Zak]

-- 
 Karel Zak  <kzak@redhat.com>
