Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZDMHzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZDMHzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 03:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZDMHzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 03:55:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZDMHzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 03:55:32 -0400
Subject: Re: USB: Buffer I/O error on device dm-0, logical block XYZ
From: Andreas <andreas@maxxle.de>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1239573569.5997.21.camel@legolas>
References: <1239573569.5997.21.camel@legolas>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 09:55:28 +0200
Message-Id: <1239609328.5997.25.camel@legolas>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/k5uNehKYCzfr8+TXJOG5r+tus9oRlVdicNn1
 Mkzv1vkIzStoHhteZjto7FGfWjSRlOtWkepurvS4zO/h+MiF5j
 k22evznvI+y6WJXCIiVRWGavKzK/iq1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More information from dmesg: 

[  223.882858] EXT3 FS on dm-0, internal journal
[  223.882917] EXT3-fs: recovery complete.
[  223.924925] EXT3-fs: mounted filesystem with ordered data mode.
[  967.909484] kjournald starting.  Commit interval 5 seconds
[  967.915929] EXT3 FS on dm-0, internal journal
[  967.917466] EXT3-fs: mounted filesystem with ordered data mode.
[ 1740.369047] ehci_hcd 0000:00:10.3: fatal error
[ 1740.370244] ehci_hcd 0000:00:10.3: HC died; cleaning up
[ 1740.370489] usb 1-3: USB disconnect, address 2
[ 1740.394603] sd 2:0:0:0: [sdb] Unhandled error code
[ 1740.394636] sd 2:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
[ 1740.394671] end_request: I/O error, dev sdb, sector 614444231
[ 1740.394867] Buffer I/O error on device dm-0, logical block 76805264
[ 1740.394943] lost page write due to I/O error on dm-0
[ 1740.394984] Buffer I/O error on device dm-0, logical block 76805265
[ 1740.395053] lost page write due to I/O error on dm-0
[ 1740.395149] sd 2:0:0:0: [sdb] Unhandled error code
[ 1740.395164] sd 2:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
[ 1740.395191] end_request: I/O error, dev sdb, sector 614444247
[ 1740.395519] Buffer I/O error on device dm-0, logical block 76805266
[ 1740.395607] lost page write due to I/O error on dm-0
[ 1740.395647] Buffer I/O error on device dm-0, logical block 76805267
[ 1740.396746] lost page write due to I/O error on dm-0
[ 1740.453282] Buffer I/O error on device dm-0, logical block 76805268
[ 1740.453424] lost page write due to I/O error on dm-0
[ 1740.469714] Buffer I/O error on device dm-0, logical block 76805269
[ 1740.469853] lost page write due to I/O error on dm-0
[ 1740.469899] Buffer I/O error on device dm-0, logical block 76805270
[ 1740.469971] lost page write due to I/O error on dm-0
[ 1740.470618] Buffer I/O error on device dm-0, logical block 76805271
[ 1740.470718] lost page write due to I/O error on dm-0
[ 1740.474334] Buffer I/O error on device dm-0, logical block 76805272
[ 1740.474445] lost page write due to I/O error on dm-0
[ 1740.474484] Buffer I/O error on device dm-0, logical block 76805273
[ 1740.474552] lost page write due to I/O error on dm-0
[ 1740.588666] JBD: Detected IO errors while flushing file data on dm-0
[ 1740.602160] Aborting journal on device dm-0.
[ 1740.645164] ext3_abort called.
[ 1740.645282] EXT3-fs error (device dm-0): ext3_journal_start_sb:
Detected aborted journal
[ 1740.645387] Remounting filesystem read-only
[ 1740.673193] usb 3-1: new full speed USB device using uhci_hcd and
address 2
[ 1741.041341] JBD: Detected IO errors while flushing file data on dm-0
[ 1741.927016] usb 3-1: not running at top speed; connect to a high
speed hub
[ 1741.959914] usb 3-1: configuration #1 chosen from 1 choice
[ 1743.164192]  uba: uba1
[ 1743.230384] usbcore: registered new interface driver ub
[ 1743.402098] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177505, block=76709892
[ 1743.402663] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177505, block=76709892
[ 1743.412724] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177506, block=76709892
[ 1743.417446] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177506, block=76709892
[ 1743.422406] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177507, block=76709892
[ 1743.423233] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177507, block=76709892
[ 1743.448445] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177508, block=76709892
[ 1743.453589] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177508, block=76709892
[ 1743.458889] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177509, block=76709892
[ 1743.459245] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177509, block=76709892
[ 1743.466356] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177510, block=76709892
[ 1743.466728] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177510, block=76709892
[ 1743.474432] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177511, block=76709892
[ 1743.474930] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177511, block=76709892
[ 1743.487927] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177512, block=76709892
[ 1743.508633] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177512, block=76709892
[ 1743.553544] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177513, block=76709892
[ 1743.554867] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177513, block=76709892
[ 1743.560664] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177514, block=76709892
[ 1743.561071] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177514, block=76709892
[ 1743.566794] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177515, block=76709892
[ 1743.567090] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177515, block=76709892
[ 1743.578335] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177516, block=76709892
[ 1743.578626] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177516, block=76709892
[ 1743.602519] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177517, block=76709892
[ 1743.602806] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177517, block=76709892
[ 1743.623868] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177518, block=76709892
[ 1743.632459] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177518, block=76709892
[ 1743.638713] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177519, block=76709892
[ 1743.639212] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177519, block=76709892
[ 1743.647400] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177520, block=76709892
[ 1743.647715] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177520, block=76709892
[ 1743.651519] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177521, block=76709893
[ 1743.651780] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177521, block=76709893
[ 1743.655171] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177522, block=76709893
[ 1743.655428] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177522, block=76709893
[ 1743.672695] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177523, block=76709893
[ 1743.672975] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177523, block=76709893
[ 1743.678953] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177524, block=76709893
[ 1743.679240] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177524, block=76709893
[ 1743.683107] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177525, block=76709893
[ 1743.683379] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable
to read inode block - inode=19177525, block=76709893
[ 1743.689641] EXT3-fs error (device dm-0): ext3_find_entry: reading
directory #19177473 offset 0
[ 1743.694495] EXT3-fs error (device dm-0): ext3_find_entry: reading
directory #19177473 offset 0
[ 1743.698144] EXT3-fs error (device dm-0): ext3_find_entry: reading
directory #19177473 offset 0
[ 1743.702033] EXT3-fs error (device dm-0): ext3_find_entry: reading
directory #19177473 offset 0
[ 1743.710452] EXT3-fs error (device dm-0): ext3_find_entry: reading
directory #12806119 offset 0
[ 1743.714198] EXT3-fs error (device dm-0): ext3_find_entry: reading
directory #12806119 offset 0
[ 1743.725600] EXT3-fs error (device dm-0): ext3_find_entry: reading
directory #12806119 offset 0
[ 1743.729815] EXT3-fs error (device dm-0): ext3_find_entry: reading
directory #12806119 offset 0


