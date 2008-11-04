Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYKDXDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYKDXDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbYKDXDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:03:38 -0500
Received: from xenotime.net ([72.52.64.118]:49170 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752864AbYKDXDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:03:37 -0500
Message-ID: <4910D1BC.9060100@xenotime.net>
Date: Tue, 04 Nov 2008 14:50:36 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
CC: corbet@lwn.net, mtk.manpages@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: [RFC] Documentation tree sub-directories reorg.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to use a few more sub-directories in the Documentation/ tree to
try to help clean it up some.  E.g., move some drivers/block/ doc files to
Documentation/blockdev/ and move some serial/tty/chardev doc files to
Documentation/serial/  (or serial-tty/ or chardev/ or <suggestions>).


A [git] diff for blockdev/ and serial/ looks like:

 Documentation/00-INDEX                      |   38 +-------------------------
 Documentation/blockdev/00-INDEX             |   16 +++++++++++
 Documentation/{ => blockdev}/README.DAC960  |    0 
 Documentation/{ => blockdev}/cciss.txt      |    0 
 Documentation/{ => blockdev}/cpqarray.txt   |    0 
 Documentation/{ => blockdev}/floppy.txt     |    0 
 Documentation/{ => blockdev}/nbd.txt        |    0 
 Documentation/{ => blockdev}/paride.txt     |    0 
 Documentation/{ => blockdev}/ramdisk.txt    |    0 
 Documentation/serial/00-INDEX               |   24 +++++++++++++++++
 Documentation/{ => serial}/README.cycladesZ |    0 
 Documentation/{ => serial}/computone.txt    |    0 
 Documentation/{ => serial}/digiepca.txt     |    0 
 Documentation/{ => serial}/hayes-esp.txt    |    0 
 Documentation/{ => serial}/moxa-smartio     |    0 
 Documentation/{ => serial}/riscom8.txt      |    0 
 Documentation/{ => serial}/rocket.txt       |    0 
 Documentation/{ => serial}/specialix.txt    |    0 
 Documentation/{ => serial}/stallion.txt     |    0 
 Documentation/{ => serial}/sx.txt           |    0 
 Documentation/{ => serial}/tty.txt          |    0 
 21 files changed, 42 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/blockdev/00-INDEX
 rename Documentation/{ => blockdev}/README.DAC960 (100%)
 rename Documentation/{ => blockdev}/cciss.txt (100%)
 rename Documentation/{ => blockdev}/cpqarray.txt (100%)
 rename Documentation/{ => blockdev}/floppy.txt (100%)
 rename Documentation/{ => blockdev}/nbd.txt (100%)
 rename Documentation/{ => blockdev}/paride.txt (100%)
 rename Documentation/{ => blockdev}/ramdisk.txt (100%)
 create mode 100644 Documentation/serial/00-INDEX
 rename Documentation/{ => serial}/README.cycladesZ (100%)
 rename Documentation/{ => serial}/computone.txt (100%)
 rename Documentation/{ => serial}/digiepca.txt (100%)
 rename Documentation/{ => serial}/hayes-esp.txt (100%)
 rename Documentation/{ => serial}/moxa-smartio (100%)
 rename Documentation/{ => serial}/riscom8.txt (100%)
 rename Documentation/{ => serial}/rocket.txt (100%)
 rename Documentation/{ => serial}/specialix.txt (100%)
 rename Documentation/{ => serial}/stallion.txt (100%)
 rename Documentation/{ => serial}/sx.txt (100%)
 rename Documentation/{ => serial}/tty.txt (100%)


Comments/thoughts?

Thanks,
~Randy
[The git tree is not currently on a shared system.]
