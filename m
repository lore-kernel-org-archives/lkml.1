Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYKMVwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYKMVwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYKMVwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:52:13 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:29591 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbYKMVwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:52:11 -0500
Message-ID: <491CA154.6020609@oracle.com>
Date: Thu, 13 Nov 2008 13:51:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL/RFC] Doc tree moves: use more sub-directory structure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.491CA15A.01C0:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC part:  when is the best time to request a pull of this git tree?
In the -rc1 merge window or some other time?

[It currently applies cleanly to linux-next and with only some of my
Documentation/ changes to mmotm.]


As a git novice, it's quite possible (or likely) that I did
something wrong here...


<trial run>


Please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/rdunlap/linux-docs doc-subdirs

to get these changes:

 Documentation/00-INDEX                      |   42 +-------------------------
 Documentation/PCI/00-INDEX                  |    2 +
 Documentation/{ => PCI}/MSI-HOWTO.txt       |    0
 Documentation/blockdev/00-INDEX             |   16 ++++++++++
 Documentation/{ => blockdev}/README.DAC960  |    0
 Documentation/{ => blockdev}/cciss.txt      |    0
 Documentation/{ => blockdev}/cpqarray.txt   |    0
 Documentation/{ => blockdev}/floppy.txt     |    0
 Documentation/{ => blockdev}/nbd.txt        |    0
 Documentation/{ => blockdev}/paride.txt     |    0
 Documentation/{ => blockdev}/ramdisk.txt    |    0
 Documentation/ioctl/00-INDEX                |   10 ++++++
 Documentation/{ => ioctl}/ioctl-number.txt  |    0
 Documentation/kernel-parameters.txt         |   24 +++++++-------
 Documentation/serial/00-INDEX               |   24 +++++++++++++++
 Documentation/{ => serial}/README.cycladesZ |    0
 Documentation/{ => serial}/computone.txt    |    2 +-
 Documentation/{ => serial}/digiepca.txt     |    0
 Documentation/{ => serial}/hayes-esp.txt    |    0
 Documentation/{ => serial}/moxa-smartio     |    0
 Documentation/{ => serial}/riscom8.txt      |    0
 Documentation/{ => serial}/rocket.txt       |    0
 Documentation/{ => serial}/specialix.txt    |    0
 Documentation/{ => serial}/stallion.txt     |    0
 Documentation/{ => serial}/sx.txt           |    0
 Documentation/{ => serial}/tty.txt          |    0
 drivers/block/Kconfig                       |   29 +++++++++---------
 drivers/block/floppy.c                      |    2 +-
 drivers/char/Kconfig                        |   24 +++++++-------
 drivers/char/specialix.c                    |    2 +-
 30 files changed, 96 insertions(+), 81 deletions(-)
 rename Documentation/{ => PCI}/MSI-HOWTO.txt (100%)
 create mode 100644 Documentation/blockdev/00-INDEX
 rename Documentation/{ => blockdev}/README.DAC960 (100%)
 rename Documentation/{ => blockdev}/cciss.txt (100%)
 rename Documentation/{ => blockdev}/cpqarray.txt (100%)
 rename Documentation/{ => blockdev}/floppy.txt (100%)
 rename Documentation/{ => blockdev}/nbd.txt (100%)
 rename Documentation/{ => blockdev}/paride.txt (100%)
 rename Documentation/{ => blockdev}/ramdisk.txt (100%)
 create mode 100644 Documentation/ioctl/00-INDEX
 rename Documentation/{ => ioctl}/ioctl-number.txt (100%)
 create mode 100644 Documentation/serial/00-INDEX
 rename Documentation/{ => serial}/README.cycladesZ (100%)
 rename Documentation/{ => serial}/computone.txt (99%)
 rename Documentation/{ => serial}/digiepca.txt (100%)
 rename Documentation/{ => serial}/hayes-esp.txt (100%)
 rename Documentation/{ => serial}/moxa-smartio (100%)
 rename Documentation/{ => serial}/riscom8.txt (100%)
 rename Documentation/{ => serial}/rocket.txt (100%)
 rename Documentation/{ => serial}/specialix.txt (100%)
 rename Documentation/{ => serial}/stallion.txt (100%)
 rename Documentation/{ => serial}/sx.txt (100%)
 rename Documentation/{ => serial}/tty.txt (100%)
