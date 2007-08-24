Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbXHXRLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbXHXRLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXHXRLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:11:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:27541 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbXHXRLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Mc3iBxbvyi5SbhIS1lgdFxNFf4SCTKrPlIZkZcZjkOfTcJ76csuYP0uMU/rCR3Ni3SsOYXp9AvfBLOYpjZYPmDK/Yu0E9v80Q2Go8ANIaMhMq6vBb6GifQrBcOLnmQ/WxGP9oqlKK8WGWN0sXDMx//VZO4+m9wcFUUwpiOlcDfk=
Message-ID: <6d4bc9fc0708241011p75d4139fg8d28273053d6bf8f@mail.gmail.com>
Date: Fri, 24 Aug 2007 19:11:42 +0200
From: "Maarten Maathuis" <madman2003@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [sata_nv] timeout waiting for ADMA IDLE, stat=0x440
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have this problem several times, always with the same harddrive, a
samsung sp2004c. My samsung hd161hj and hd321kj don't seem to suffer
from this problem. I do not know when exactly it happened for the
first, but it has happened twice on a 2.6.22 kernel.

Is there anything that can be done about this (besides disabling adma
for all drives), or any information i can provide to help?

Please CC me, as i am not a member of this mailinglist.

Sincerely,

Maarten Maathuis.

dmesg snippet:

ata4: timeout waiting for ADMA IDLE, stat=0x440
ata4.00: qc timeout (cmd 0x2f)
ata4: failed to read log page 10h (errno=-5)
ata4.00: exception Emask 0x1 SAct 0x1 SErr 0x380000 action 0x2 frozen
ata4.00: (CPB resp_flags 0x11: CMD error)
ata4.00: cmd 60/80:00:89:b0:30/00:00:02:00:00/40 tag 0 cdb 0x0 data 65536 in
         res 51/84:00:02:00:00/84:00:02:00:00/40 Emask 0x10 (ATA bus error)
ata4: port is slow to respond, please be patient (Status 0xd1)
ata4: device not ready (errno=-16), forcing hardreset
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: COMRESET failed (errno=-16)
ata4: reset failed, giving up
ata4.00: disabled
ata4: EH pending after completion, repeating EH (cnt=4)
ata4: exception Emask 0x10 SAct 0x0 SErr 0x3d0000 action 0x2 frozen
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: COMRESET failed (errno=-16)
ata4: reset failed, giving up
ata4: EH pending after completion, repeating EH (cnt=3)
ata4: exception Emask 0x10 SAct 0x0 SErr 0x3d0000 action 0x2 frozen
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: COMRESET failed (errno=-16)
ata4: reset failed, giving up
ata4: EH pending after completion, repeating EH (cnt=2)
ata4: exception Emask 0x10 SAct 0x0 SErr 0x3d0000 action 0x2 frozen
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: COMRESET failed (errno=-16)
ata4: reset failed, giving up
ata4: EH pending after completion, repeating EH (cnt=1)
ata4: exception Emask 0x10 SAct 0x0 SErr 0x3d0000 action 0x2 frozen
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: COMRESET failed (errno=-16)
ata4: reset failed, giving up
ata4: EH pending after 5 tries, giving up
sd 3:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 3:0:0:0: [sdc] Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        02 00 00 02
sd 3:0:0:0: [sdc] Add. Sense: Scsi parity error
end_request: I/O error, dev sdc, sector 36745353
ata4: EH complete
ata4.00: detaching (SCSI 3:0:0:0)
sd 3:0:0:0: [sdc] Synchronizing SCSI cache
sd 3:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
sd 3:0:0:0: [sdc] Stopping disk
sd 3:0:0:0: [sdc] START_STOP FAILED
sd 3:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
scsi 3:0:0:0: rejecting I/O to dead device
scsi 3:0:0:0: rejecting I/O to dead device
scsi 3:0:0:0: rejecting I/O to dead device
scsi 3:0:0:0: rejecting I/O to dead device
scsi 3:0:0:0: rejecting I/O to dead device
