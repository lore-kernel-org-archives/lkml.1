Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614Ab0A0X4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0A0X4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525Ab0A0X4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:56:45 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:36302 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab0A0X4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:56:44 -0500
X-Greylist: delayed 1397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 18:56:44 EST
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Subject: Warning: dev (ttyS1) tty->count(6) != #fd's(5) in tty_release_dev
Date: Thu, 28 Jan 2010 00:33:22 +0100
Message-ID: <878wbjp1h9.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I often get several such messages during system boot, at least when udev
is in debug mode (udev_log="debug") and console=ttyS1,19200n8r under
Linux 2.6.32 and udev 150.  The numbers vary, but they are always small
and the difference is always one.  For example, as captured on a serial
line:

udevd-work[  140.719498] Warning: dev (ttyS1) tty->count(7) != #fd's(6) in tty_release_dev
[113]: seq 628 p[  140.770449] Warning: dev (ttyS1) tty->count(7) != #fd's(6) in tty_release_dev
rocessed with 0
[...]
usb_[  141.585263] sd 1:0:0:0: [sdb] Add. Sense: Logical unit not ready, manual intervention required
id[266]: device [  141.585269] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  141.585276] end_request: I/O error, dev sdb, sector 0
0x9f3c068 has de[  141.827050] Warning: dev (ttyS1) tty->count(5) != #fd's(4) in tty_release_dev
vpath '/devices/[  141.878019] Warn.rules:40
[...]
udevd-work[127]:[  151.518217] sd 2:0:0:0: [sdd] Sense Key : Not Ready [current] 
 creating device[  151.518220] sd 2:0:0:0: [sdd] Add. Sense: Logical unit not ready, manual intervention required
 node '/dev/bsg/[  151.518226] sd 2:0:0:0: [sdd] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  151.518233] end_request: I/O error, dev sdd, sector 0
0:0:0:0', devnum[  151.760024] Warning: dev (ttyS1) tty->count(3) != #fd's(2) in tty_release_dev
=253:0, mode=066[  151.816122] sd 2:0:0:0: [sdd] Device not ready
0, uid=0, gid=0[  151.845797] sd 2:0:0:0: [sdd] 

I wonder if it rings some bells here...
-- 
Regards,
Feri.
