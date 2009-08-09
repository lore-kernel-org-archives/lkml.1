Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbZHIJIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbZHIJIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZHIJIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:08:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59134 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbZHIJII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:08:08 -0400
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: moving "tools" into the tools/ directory?
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.00.0908081156210.9362@localhost>
	<87bpmqt5b2.fsf@basil.nowhere.org>
Date: Sun, 09 Aug 2009 11:08:02 +0200
In-Reply-To: <87bpmqt5b2.fsf@basil.nowhere.org> (Andi Kleen's message of "Sat, 08 Aug 2009 22:32:33 +0200")
Message-ID: <877hxdtkwd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> "Robert P. J. Day" <rpjday@crashcourse.ca> writes:
>
>>   is there a standard for moving command-line tools into the top-level
>> tools/ directory?  as in, Documentation/fs/slabinfo.c?  stuff like
>> that?
>
> I did some moving of such files from Documentation to tool in a git
> tree some time ago, but to make it actually all build sanely --
> especially with separate objdirs and/or cross compilation -- would
> require major Makefile surgery first.

As a followup the original rename git tree (with still some problems)
is at 

git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git tools-rename

In case anyone wants to play with it.

-Andi


The following changes since commit 28d0325ce6e0a52f53d8af687e6427fee59004d3:
  Linus Torvalds (1):
        Linux 2.6.31-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git tools-rename

Andi Kleen (14):
      Add top level Kbuild makefile in tools/
      Move Documentation/connector source files to tools/connector
      Move Documentation/watchdog/src to tools/watchdog
      Move Documentation/lguest source files to tools
      Move source files from Documentation/accounting to tools/accounting
      Mov source files from Documentation/vm to tools/vm
      Move source files from Documentation/networking to tools/networking
      Move source files in Documentation/ia64 to tools/ia64
      Move Documentation/prctl to tools/prctl
      Move source files from Documentation/auxdisplay to tools/auxdisplay
      Move source files from Documentation/video4linux to tools/video4linux
      Move source files in Documentation/pcmcia into tools/pcmcia
      Move source files from Documentation/spi to tools/spi
      lguest fix, incomplete

 Documentation/Makefile                             |    4 +---
 Documentation/lguest/Makefile                      |    7 -------
 tools/Makefile                                     |    4 ++++
 {Documentation => tools}/accounting/.gitignore     |    0
 {Documentation => tools}/accounting/Makefile       |    2 +-
 {Documentation => tools}/accounting/getdelays.c    |    0
 {Documentation => tools}/auxdisplay/.gitignore     |    0
 {Documentation => tools}/auxdisplay/Makefile       |    0
 .../auxdisplay/cfag12864b-example.c                |    0
 {Documentation => tools}/connector/.gitignore      |    0
 {Documentation => tools}/connector/Makefile        |    0
 {Documentation => tools}/connector/cn_test.c       |    0
 {Documentation => tools}/connector/ucon.c          |    0
 {Documentation => tools}/ia64/.gitignore           |    0
 {Documentation => tools}/ia64/Makefile             |    0
 {Documentation => tools}/ia64/aliasing-test.c      |    0
 {Documentation => tools}/lguest/.gitignore         |    0
 .../video4linux => tools/lguest}/Makefile          |    8 +++++---
 {Documentation => tools}/lguest/extract            |    0
 {Documentation => tools}/lguest/lguest.c           |    0
 {Documentation => tools}/networking/Makefile       |    0
 {Documentation => tools}/networking/ifenslave.c    |    0
 .../networking/timestamping/.gitignore             |    0
 .../networking/timestamping/Makefile               |    0
 .../networking/timestamping/timestamping.c         |    0
 {Documentation => tools}/pcmcia/.gitignore         |    0
 {Documentation => tools}/pcmcia/Makefile           |    0
 {Documentation => tools}/pcmcia/crc32hash.c        |    0
 .../prctl/disable-tsc-ctxt-sw-stress-test.c        |    0
 .../prctl/disable-tsc-on-off-stress-test.c         |    0
 {Documentation => tools}/prctl/disable-tsc-test.c  |    0
 {Documentation => tools}/spi/.gitignore            |    0
 {Documentation => tools}/spi/Makefile              |    0
 {Documentation => tools}/spi/spidev_fdx.c          |    0
 {Documentation => tools}/spi/spidev_test.c         |    0
 {Documentation => tools}/video4linux/.gitignore    |    0
 {Documentation => tools}/video4linux/Makefile      |    0
 {Documentation => tools}/video4linux/v4lgrab.c     |    0
 {Documentation => tools}/vm/.gitignore             |    0
 {Documentation => tools}/vm/Makefile               |    0
 {Documentation => tools}/vm/page-types.c           |    0
 {Documentation => tools}/vm/slabinfo.c             |    0
 .../watchdog/src => tools/watchdog}/.gitignore     |    0
 .../watchdog/src => tools/watchdog}/Makefile       |    0
 .../src => tools/watchdog}/watchdog-simple.c       |    0
 .../src => tools/watchdog}/watchdog-test.c         |    0
 46 files changed, 11 insertions(+), 14 deletions(-)
 delete mode 100644 Documentation/lguest/Makefile
 create mode 100644 tools/Makefile
 rename {Documentation => tools}/accounting/.gitignore (100%)
 rename {Documentation => tools}/accounting/Makefile (80%)
 rename {Documentation => tools}/accounting/getdelays.c (100%)
 rename {Documentation => tools}/auxdisplay/.gitignore (100%)
 rename {Documentation => tools}/auxdisplay/Makefile (100%)
 rename {Documentation => tools}/auxdisplay/cfag12864b-example.c (100%)
 rename {Documentation => tools}/connector/.gitignore (100%)
 rename {Documentation => tools}/connector/Makefile (100%)
 rename {Documentation => tools}/connector/cn_test.c (100%)
 rename {Documentation => tools}/connector/ucon.c (100%)
 rename {Documentation => tools}/ia64/.gitignore (100%)
 rename {Documentation => tools}/ia64/Makefile (100%)
 rename {Documentation => tools}/ia64/aliasing-test.c (100%)
 rename {Documentation => tools}/lguest/.gitignore (100%)
 copy {Documentation/video4linux => tools/lguest}/Makefile (50%)
 rename {Documentation => tools}/lguest/extract (100%)
 rename {Documentation => tools}/lguest/lguest.c (100%)
 rename {Documentation => tools}/networking/Makefile (100%)
 rename {Documentation => tools}/networking/ifenslave.c (100%)
 rename {Documentation => tools}/networking/timestamping/.gitignore (100%)
 rename {Documentation => tools}/networking/timestamping/Makefile (100%)
 rename {Documentation => tools}/networking/timestamping/timestamping.c (100%)
 rename {Documentation => tools}/pcmcia/.gitignore (100%)
 rename {Documentation => tools}/pcmcia/Makefile (100%)
 rename {Documentation => tools}/pcmcia/crc32hash.c (100%)
 rename {Documentation => tools}/prctl/disable-tsc-ctxt-sw-stress-test.c (100%)
 rename {Documentation => tools}/prctl/disable-tsc-on-off-stress-test.c (100%)
 rename {Documentation => tools}/prctl/disable-tsc-test.c (100%)
 rename {Documentation => tools}/spi/.gitignore (100%)
 rename {Documentation => tools}/spi/Makefile (100%)
 rename {Documentation => tools}/spi/spidev_fdx.c (100%)
 rename {Documentation => tools}/spi/spidev_test.c (100%)
 rename {Documentation => tools}/video4linux/.gitignore (100%)
 rename {Documentation => tools}/video4linux/Makefile (100%)
 rename {Documentation => tools}/video4linux/v4lgrab.c (100%)
 rename {Documentation => tools}/vm/.gitignore (100%)
 rename {Documentation => tools}/vm/Makefile (100%)
 rename {Documentation => tools}/vm/page-types.c (100%)
 rename {Documentation => tools}/vm/slabinfo.c (100%)
 rename {Documentation/watchdog/src => tools/watchdog}/.gitignore (100%)
 rename {Documentation/watchdog/src => tools/watchdog}/Makefile (100%)
 rename {Documentation/watchdog/src => tools/watchdog}/watchdog-simple.c (100%)
 rename {Documentation/watchdog/src => tools/watchdog}/watchdog-test.c (100%)



-- 
ak@linux.intel.com -- Speaking for myself only.
