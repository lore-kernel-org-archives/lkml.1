Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZCYWnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZCYWnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZCYWni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:43:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41580 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZCYWnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=hALrZRTMqvq/SLbu3uNvnA41giIlKVV2bvIQMvx8IfEcQWzKTjGlbOuCCMrRmptQOc
         6Mr4JnTjX8HfSv/gt467vFnjBhgZINbmdj2ohC93avJzTbu4VxF4Wfhj7agR07CRHFR0
         8BJNEdlVklHtonyuVbS9GmUcOXfTwNgCzbHSg=
Message-ID: <49CAB39A.4060208@devnull.org>
Date: Thu, 26 Mar 2009 00:43:38 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: EXT4: __ext4_get_inode_loc errors after s2disk
References: <cjlqb-7sp-1@gated-at.bofh.it> <cjJLV-4jA-15@gated-at.bofh.it>
In-Reply-To: <cjJLV-4jA-15@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2009 12:30 AM, Pavel Machek wrote:
> On Tue 2009-03-24 22:25:57, Niel Lambrechts wrote:
>> After upgrading to 2.6.29 I get the below errors after resuming from
>> hibernating with s2disk. I ran fsck and tried doing the same thing again
>> in 2.6.28.9-pae, but do not get any errors there.
> 
> what kind of disk/what kind of controller is that?

Hi Pavel,

It is a Lenovo W500 Thinkpad.

lspci shows:

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI
Controller (rev 03)

and for the disk, hdparm shows:
/dev/sda:

 Model=HITACHI HTS722020K9SA00  FDE            , FwRev=DC4LC75A,
SerialNo=080726DP0470DTGMUNPC
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=DualPortCache, BuffSize=15203kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=390721968
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=yes: mode=0x80 (128) WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-2,3,4,5,6,7

 * signifies the current active mode


Niel
