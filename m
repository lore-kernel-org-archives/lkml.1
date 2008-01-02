Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYABVLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYABVLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYABVK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:10:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbYABVKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:10:55 -0500
Date: Wed, 2 Jan 2008 22:10:52 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng 2.13.1-rc2
Message-ID: <20080102211052.GC23824@petra.dvoda.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 The second util-linux-ng 2.13.1 release candidate is available at

    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/

 (Note, 2.13.1 is stable maintenance release.)

 Feedback and bug reports, as always, are welcomed.

	Karel


v2.13.1-rc2 Changelog:
----------------------

blockdev:
   - add --getsz to blockdev.8  [Karel Zak]
build-sys:
   - release++ (-rc2)  [Karel Zak]
   - remove hardcoded _GNU_SOURCE  [Karel Zak]
docs:
   - add note about incorrect tag 2.13.1  [Karel Zak]
   - update AUTHORS file, add all translators  [Karel Zak]
   - update ReleaseNotes  [Karel Zak]
getopt:
   - fix path to examples in getopt.1  [Karel Zak]
hwclock:
   - check for ENODEV  [David Woodhouse]
mount:
   - don't call canonicalize(SPEC) for cifs, smbfs and nfs  [Karel Zak]
   - fix fd leak  [Matthias Koenig]
po:
   - add eu.po (from translationproject.org)  [Mikel Olasagasti]
   - add pl.po (from translationproject.org)  [Andrzej Krzysztofowicz]
   - update ca.po (from translationproject.org)  [Josep Puigdemont]
   - update cs.po (from translationproject.org)  [Petr Pisar]
   - update da.po (from translationproject.org)  [Claus Hindsgaul]
   - update de.po (from translationproject.org)  [Michael Piefel]
   - update es.po (from translationproject.org)  [Santiago Vila Doncel]
   - update et.po (from translationproject.org)  [Meelis Roos]
   - update fi.po (from translationproject.org)  [Lauri Nurmi]
   - update fr.po (from translationproject.org)  [Michel Robitaille]
   - update hu.po (from translationproject.org)  [Gabor Kelemen]
   - update id.po (from translationproject.org)  [Arif E. Nugroho]
   - update it.po (from translationproject.org)  [Marco Colombo]
   - update ja.po (from translationproject.org)  [Daisuke Yamashita]
   - update nl.po (from translationproject.org)  [Benno Schulenberg]
   - update po files  [Karel Zak]
   - update pt_BR.po (from translationproject.org)  [Rodrigo Stulzer Lopes]
   - update ru.po (from translationproject.org)  [Pavel Maryanov]
   - update sl.po (from translationproject.org)  [Simon Mihevc]
   - update sv.po (from translationproject.org)  [Daniel Nylander]
   - update tr.po (from translationproject.org)  [Nilgün Belma Bugüner]
   - update uk.po (from translationproject.org)  [Maxim V. Dziumanenko]
   - update vi.po (from translationproject.org)  [Clytie Siddall]
sfdisk:
   - allow partitioning drives of over 2^31 sectors.  [Kunihiko IMAI]



v2.13.1-rc2 diffstat:
---------------------

 AUTHORS                   |   38 +-
 NEWS                      |    5 +
 README.devel              |    4 +
 configure.ac              |    2 +-
 disk-utils/blockdev.8     |    9 +-
 disk-utils/fsck.cramfs.c  |    1 -
 docs/v2.13.1-ReleaseNotes |   36 +-
 fdisk/sfdisk.c            |    3 +-
 getopt/getopt.1           |    5 +-
 hwclock/rtc.c             |    2 +-
 mount/lomount.c           |    1 +
 mount/mount.c             |   21 +-
 po/ca.po                  |  258 +-
 po/cs.po                  |  324 +-
 po/da.po                  |  256 +-
 po/de.po                  |  540 ++--
 po/es.po                  |  275 +-
 po/et.po                  |  441 +--
 po/eu.po                  | 9466 ++++++++++++++++++++++++++++++++++++++++++++
 po/fi.po                  |  240 +-
 po/fr.po                  |  281 +-
 po/hu.po                  | 1735 +++++----
 po/id.po                  |  291 +-
 po/it.po                  |  306 +-
 po/ja.po                  |  501 +--
 po/nl.po                  |  328 +-
 po/pl.po                  | 9467 +++++++++++++++++++++++++++++++++++++++++++++
 po/pt_BR.po               |  708 ++--
 po/ru.po                  |  280 +-
 po/sl.po                  |  260 +-
 po/sv.po                  |  291 +-
 po/tr.po                  |  286 +-
 po/uk.po                  |  274 +-
 po/util-linux-ng.pot      |  240 +-
 po/vi.po                  |  310 +-
 schedutils/chrt.c         |    2 -
 schedutils/taskset.c      |    2 -
 sys-utils/setarch.c       |    4 -
 38 files changed, 23079 insertions(+), 4414 deletions(-)

-- 
 Karel Zak  <kzak@redhat.com>
