Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbXJFRLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbXJFRLp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 13:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXJFRLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 13:11:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:37717 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbXJFRLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 13:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=RcY2NGQjwtJLgaPg8iDXxz13ae9gGjxD8zLXA7DMfOZtKTx6LHxe0rU4rV9bFVjZOwE8Y4+wYBiFK1ykGv60z2GKZhG5AahZ5cWaUvBiflWHDWIyGM65yCziU7DBOpXb2b0VzxpGFq8tt8pBX6v6+wO7Aaz8wmladt0u+gTav/c=
Message-ID: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>
Date: Sat, 6 Oct 2007 12:11:35 -0500
From: "Mark Weber" <crash@treysoft.com>
Reply-To: crash@treysoft.com
To: linux-kernel@vger.kernel.org
Subject: hdparm standby timeout not working for WD raptors?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 8b3b2d31aeae00ba
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can't get "hdparm -S" to work at all.

Using  "hdparm -S 1" should set the timeout to
5 seconds,  but the drives stay active/idle all the
time. When I set to standby manually, the drives
stay on standby for days, and start up fine when
they are used. I know this because I logged status
every 30 minutes using crontab.

They just don't standby automatically.

I'm using 5 identical drives (see below for drive
info), with software RAID.

Any suggestions? System details follow.


# uname -a
Linux narf 2.6.22-gentoo-r5 #1 Sat Sep 1 13:35:06 CDT 2007 i686
Intel(R) Celeron(R) D CPU 420 @ 1.60GHz GenuineIntel GNU/Linux

# hdparm -S 1 /dev/sda
 setting standby to 1 (5 seconds)

# hdparm -I /dev/sda

/dev/sda:

ATA device, with non-removable media
        Model Number:       WDC WD5000ABYS-01TNA0
        Serial Number:      WD-WCAPW2171884
        Firmware Revision:  12.01C01
Standards:
        Supported: 7 6 5 4
        Likely used: 7
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:   16514064
        LBA    user addressable sectors:  268435455
        LBA48  user addressable sectors:  976773168
        device size with M = 1024*1024:      476940 MBytes
        device size with M = 1000*1000:      500107 MBytes (500 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, with device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 16
        Recommended acoustic management value: 128, current value: 254
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=120ns  IORDY flow control=120ns
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
                Power-Up In Standby feature set
           *    SET_FEATURES required to spinup after power up
                SET_MAX security extension
           *    Automatic Acoustic Management feature set
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
           *    64-bit World wide name
           *    Segmented DOWNLOAD_MICROCODE
           *    SATA-I signaling speed (1.5Gb/s)
           *    SATA-II signaling speed (3.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Phy event counters
                DMA Setup Auto-Activate optimization
           *    Software settings preservation
           *    SMART Command Transport (SCT) feature set
           *    SCT Long Sector Access (AC1)
           *    SCT LBA Segment Access (AC2)
           *    SCT Error Recovery Control (AC3)
           *    SCT Features Control (AC4)
           *    SCT Data Tables (AC5)
                unknown 206[12]
                unknown 206[13]
Security:
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
        not     supported: enhanced erase
        134min for SECURITY ERASE UNIT.
Checksum: correct
