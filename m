Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXEYLYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXEYLYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbXEYLY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:24:29 -0400
Received: from web54501.mail.re2.yahoo.com ([206.190.49.151]:44370 "HELO
	web54501.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751312AbXEYLY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:24:28 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 07:24:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=avU6JeARl1eJ6Ozg9AeFS/NxFUxgXnhf0XD9NbcVj8j1z/u15J/q2dIwAI0LPB9/g3+CuB79wgCZBmX43ohqZj7T90d5mldoZNbdRpDWkOdZi8tLUmdToR0lMy1YowOY3f7M2S7z+ibI1DbyWOYdDqAjG5wPb9xX0QO+/CDpItY=;
X-YMail-OSG: mzTuCYEVM1ln.1opmGba0.wFB.U6rrAbBMJV54QnHGc9A8eGLvtQOtgoYJrW3FCgre.Ui.DWyqS6ixaMJOVkLFRXoa_QL1fnUXJvzDPS8n8pSoucnXKK8u.RwcMaQSiI7hknsUvIL_0nBTA-
Date: Fri, 25 May 2007 20:07:13 +0900 (KST)
From: yong Jung <yong_jk@yahoo.com>
Subject: HPA patch doesn't  work on my SATA, kernel-2.6.18
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Message-ID: <252323.91530.qm@web54501.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
.
I want to remove HPA in SATA, I was recommended to
follow this linux-ide site.
http://www.mail-archive.com/linux-lde@vger.kernel.org/msg05215.html
I want to remove HPA area under Kernel-2.6.18.
But after patching ,I couldn't see anything like HPA
in dmesg and fdisk information.
There is no difference between before and after patch.
Now I am using SATA 250GB includes HPA, 11GB.
And I installed HDPARM7.3,which support SATA, to get
some information.
But there's nothing related to my SATA 250GB, HPA.
In the output of "HDPARM -I /dev/sda" there is a
device size, 239GB, but that doesn't include HPA area.
Could you please tell me which kernel patch, program
or commands to use in order to remove HPA area under
Linux ?
.......................
[root@localhost hdparm-7.3]# ./hdparm -I /dev/sda
/dev/sda:
ATA device, with non-removable media
        Model Number:       SAMSUNG SP2504C
        Serial Number:      S0H9J1QP400136
        Firmware Revision:  VT100-50
Standards:
        Used: ATA/ATAPI-7 T13 1532D revision 4a
        Supported: 7 6 5 4
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:   16514064
        LBA    user addressable sectors:  268435455
        LBA48  user addressable sectors:  467348955
        device size with M = 1024*1024:      228197
MBytes
        device size with M = 1000*1000:      239282
MBytes (239 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no
device specific minimum
        R/W multiple sector transfer: Max = 16 
Current = 16
        Recommended acoustic management value: 254,
current value: 128
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3
udma4 *udma5 udma6 udma7
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=120ns  IORDY
flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    NOP cmd
           *    DOWNLOAD_MICROCODE
           *    SET_MAX security extension
           *    Automatic Acoustic Management feature
set
           *    48-bit Address feature set
           *    Device Configuration Overlay feature
set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    Segmented DOWNLOAD_MICROCODE
           *    SATA-I signaling speed (1.5Gb/s)
           *    SATA-II signaling speed (3.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Host-initiated interface power
management
           *    Phy event counters
                DMA Setup Auto-Activate optimization
                Device-initiated interface power
management
           *    Software settings preservation
           *    SMART Command Transport (SCT) feature
set
           *    SCT Long Sector Access (AC1)
           *    SCT LBA Segment Access (AC2)
           *    SCT Error Recovery Control (AC3)
           *    SCT Features Control (AC4)
           *    SCT Data Tables (AC5)
Security:
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
                supported: enhanced erase
        88min for SECURITY ERASE UNIT. 88min for
ENHANCED SECURITY ERASE UNIT.
Checksum: correct
[root@localhost hdparm-7.3]#
.
Friendly,
Nobel


      ________________________________________________________ 
180도 달라진 야후! 메일 - 탄탄한 보안! 새로운 야후! 메일의 ‘안전주소'기능으로 스팸을 차단하세요.
http://kr.content.mail.yahoo.com/cgland
