Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZJDBD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZJDBD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 21:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZJDBD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 21:03:27 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:45391 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbZJDBD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 21:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pTa/+IoGzhwvH2W3ow/5jw3ntiam2deulCoOcRPM9xtRXRggjbK66Y/5rIzguJdy9J
         dB6Bu9L99OHWx6lblndNeQlmMbvJbRlCgGEznW5FGhJ40P5Ld+119JqIyC8UZv3NoWbD
         9b5n2SE4sM88JtGdTA5sXAU9y+qJE2keOxifM=
Message-ID: <4AC7F411.1090305@gmail.com>
Date: Sat, 03 Oct 2009 19:02:09 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: /dev/sdb not detected anymore?
References: <804dabb00910020707r9820d8bpe371baf1efb67c1@mail.gmail.com>
In-Reply-To: <804dabb00910020707r9820d8bpe371baf1efb67c1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2009 08:07 AM, Peter Teoh wrote:
> I just built my 2.6.32-rc2 (from linus-git) yesterday, and repeated
> today again, starting from "make mrproper", and consistently both
> version cannot detect my /dev/sdb, which is the second SATA harddisk.
>   The first SATA is detected as follows in dmesg:
>
>      742 [    4.595949] scsi 2:0:0:0: Direct-Access     ATA
> ST3500630AS      3.AA PQ: 0 ANSI: 5
>      743 [    4.596116] sd 2:0:0:0: [sda] 976773168 512-byte logical
> blocks: (500 GB/465 GiB)
>      744 [    4.596213] sd 2:0:0:0: [sda] Write Protect is off
>      745 [    4.596216] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
>      746 [    4.596258] sd 2:0:0:0: [sda] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
>      747 [    4.596467]  sda: sda1 sda2 sda3 sda4<  sda5 sda6 sda7 sda8 sda9>
>      748 [    4.674607] sd 2:0:0:0: [sda] Attached SCSI disk
>
> And from sg_inq:
>
> standard INQUIRY:
>    PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
>    [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>    SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
>    EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>    [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
>    [SPI: Clocking=0x0  QAS=0  IUS=0]
>      length=96 (0x60)   Peripheral device type: disk
>   Vendor identification: ATA
>   Product identification: ST3500630AS
>   Product revision level: 3.AA
>   Unit serial number:             9QG14T5Z
>
> But the second SATA (identical in type/model) is not detectable.
> Upon rebooting to my previous 2.6.31 kernel version, it became
> detected and usable - absolutely nothing else is touch.   So what is
> it in the latest kernel which is giving the problem?

We need more details, can you post the full boot log including the 
actual libata messages from the working and non-working kernels?
