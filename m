Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZECNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZECNBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 09:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZECNBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 09:01:14 -0400
Received: from mailgate.ics.forth.gr ([139.91.1.2]:44964 "EHLO
	mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbZECNBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 09:01:13 -0400
X-Greylist: delayed 3174 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 May 2009 09:01:12 EDT
From: Panagiotis Papadakos <papadako@csd.uoc.gr>
Organization: Computer Science Department - University of Crete
To: linux-kernel@vger.kernel.org
Subject: 2.6.30-rc4 Weird messages with ext4
Date: Sun, 3 May 2009 15:08:05 +0300
User-Agent: KMail/1.11.2 (Linux/2.6.30-2-generic; KDE/4.2.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mkY/J+UrIV5cnUK"
Message-Id: <200905031508.06053.papadako@csd.uoc.gr>
X-j-chkmail-Score: MSGID : 49FD8932.000 on mailgate : j-chkmail score : . : R=. U=. O=. B=0.000 -> S=0.000
X-ICS-JCHK-SCL: Ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_mkY/J+UrIV5cnUK
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi.

When I connect my ext4 formatted Seagate 1.5 TB USB box,
I get the messages of the style:

[sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE           
[sdb] Sense Key : Illegal Request [current]                     
[sdb] Add. Sense: Logical block address out of range 

By the way I am not getting such messages with 2.6.29.

Anyone knows what might be wrong?




--Boundary-00=_mkY/J+UrIV5cnUK
Content-Type: text/plain;
  charset="UTF-8";
  name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="messages"

Apr 27 20:42:15 cray-7 kernel: [    7.600940] scsi 2:0:0:0: Direct-Access     ST315003 41AS                  PQ: 0 ANSI: 2
Apr 27 20:42:15 cray-7 kernel: [    7.601701] sd 2:0:0:0: Attached scsi generic sg2 type 0
Apr 27 20:42:15 cray-7 kernel: [    7.623420] sd 2:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
Apr 27 20:42:15 cray-7 kernel: [    7.624694] sd 2:0:0:0: [sdb] Using 0xffffffff as device size
Apr 27 20:42:15 cray-7 kernel: [    7.624703] sd 2:0:0:0: [sdb] 4294967296 512-byte hardware sectors: (2.19 TB/2.00 TiB)
Apr 27 20:42:15 cray-7 kernel: [    7.627074] sd 2:0:0:0: [sdb] Write Protect is off
Apr 27 20:42:15 cray-7 kernel: [    7.649077] sd 2:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
Apr 27 20:42:15 cray-7 kernel: [    7.650288] sd 2:0:0:0: [sdb] Using 0xffffffff as device size
Apr 27 20:42:15 cray-7 kernel: [    7.652566]  sdb: unknown partition table
Apr 27 20:42:15 cray-7 kernel: [    7.674807] sd 2:0:0:0: [sdb] Attached SCSI disk
Apr 27 20:42:15 cray-7 kernel: [    7.683409] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.683418] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.683425] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.684803] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.684810] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.684816] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.686177] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.686183] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.686189] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.687526] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.687532] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.687538] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.688904] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.688909] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.688915] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.691278] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.691283] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.691289] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.692654] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.692659] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.692665] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.694028] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.694034] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.694040] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.695404] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.695410] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.695416] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.697018] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.697022] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.697026] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.698272] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.698276] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.698280] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.699528] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.699533] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.699543] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.700770] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.700777] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.700784] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.702178] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.702183] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.702189] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.703527] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.703532] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.703538] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [    7.743957] kjournald starting.  Commit interval 5 seconds
Apr 27 20:42:15 cray-7 kernel: [    7.743976] EXT3-fs: mounted filesystem with writeback data mode.
Apr 27 20:42:15 cray-7 kernel: [   26.251963] udev: starting version 141
Apr 27 20:42:15 cray-7 kernel: [   26.380516] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.380523] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.380527] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.380537] __ratelimit: 5 callbacks suppressed
Apr 27 20:42:15 cray-7 kernel: [   26.382893] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.382899] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.382903] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.384261] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.384265] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.384270] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.385517] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.385522] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.385526] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.386887] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.386892] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.386896] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.389163] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.389171] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.389175] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.390522] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.390527] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.390532] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.391890] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.391895] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.391899] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.394356] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.394361] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.394366] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.396635] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.396641] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.396646] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.398261] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.398266] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.398271] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.399537] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.399543] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.399548] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.400890] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.400895] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.400900] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.402138] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.402143] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.402147] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
Apr 27 20:42:15 cray-7 kernel: [   26.403510] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [   26.403514] sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [   26.403519] sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
--Boundary-00=_mkY/J+UrIV5cnUK--
