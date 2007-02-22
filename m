Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbXBVWre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbXBVWre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXBVWre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:47:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:54412 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbXBVWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i7Td176avgqe4kQTma8hcOO/zsU7qmxNWfTcpX/EQEHLm0Y6yaZlmRlcPjQlzY6YT3r5jzq/913R4/XqU5RqLWc+g3/Id83qRzqueo+f6tXyvZW+67UKR+PSvCENNjMF+6UTydAK3xrSxIxlNqp6XxiXPVeZyz0lUQ84+sCgjyA=
Message-ID: <e5ab0f710702221447u7367977ie06a6e2b180ae7f8@mail.gmail.com>
Date: Thu, 22 Feb 2007 23:47:31 +0100
From: "Francesco Pretto" <ceztko@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
In-Reply-To: <20070222135306.4eb757c2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5ab0f710702211415p37444279td690c2db4b4ca8ab@mail.gmail.com>
	 <20070221235541.35f3d0da@lxorguk.ukuu.org.uk>
	 <e5ab0f710702211701u4c5b62c5jb560f166641512ff@mail.gmail.com>
	 <20070222135306.4eb757c2@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/22, Alan <alan@lxorguk.ukuu.org.uk>:

>
> The following will generate a vast amount of debug of which only the end
> matters.
>

For some reason, related to my current distro, i didn't used init=/bin/sh .
The full, bloated, log is here http://www.webalice.it/ceztko/log1
(taken from launch of "poweroff"). I can confirm, as Rolf Offermanns
noted, that "halt -f" doesn't cut the power.

An extract is here. However i'm worried that the log is trunkated. Is
netconsole good enough to use in this case?

[17179886.052000] ata_scsi_dump_cdb: CDB (1:0,0,0) 2a 00 07 5b dd 90 00 00 08
[17179886.052000] ata_scsi_translate: ENTER
[17179886.052000] scsi_10_lba_len: ten-byte command
[17179886.052000] ata_sg_setup: ENTER, ata1
[17179886.052000] ata_sg_setup: 1 sg elements mapped
[17179886.052000] ata_fill_sg: PRD[0] = (0x2317000, 0x1000)
[17179886.052000] ata_dev_select: ENTER, ata1: device 0, wait 1
[17179886.052000] ata_tf_load_pio: feat 0x0 nsect 0x8 lba 0x90 0xDD 0x5B
[17179886.052000] ata_tf_load_pio: device 0xE7
[17179886.052000] ata_exec_command_pio: ata1: cmd 0xCA
[17179886.052000] ata_scsi_translate: EXIT
[17179886.052000] ata_host_intr: ata1: host_stat 0x24
[17179886.052000] ata_host_intr: ata1: protocol 3 (dev_stat 0x50)
[17179886.052000] ata_sg_clean: unmapping 1 sg elements
[17179886.056000] rc(4351): READ block 309568 on sda6
[17179886.056000] ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 07 5f 96 40 00 00 08
[17179886.056000] ata_scsi_translate: ENTER
[17179886.056000] scsi_10_lba_len: ten-byte command
[17179886.056000] ata_sg_setup: ENTER, ata1
[17179886.056000] ata_sg_setup: 1 sg elements mapped
[17179886.056000] ata_fill_sg: PRD[0] = (0x7E992000, 0x1000)
[17179886.056000] ata_dev_select: ENTER, ata1: device 0, wait 1
[17179886.056000] ata_tf_load_pio: feat 0x0 nsect 0x8 lba 0x40 0x96 0x5F
[17179886.056000] ata_tf_load_pio: device 0xE7
[17179886.056000] ata_exec_command_pio: ata1: cmd 0xC8
[17179886.056000] ata_scsi_translate: EXIT
[17179886.064000] ata_host_intr: ata1: host_stat 0x24
[17179886.064000] ata_host_intr: ata1: protocol 3 (dev_stat 0x50)
[17179886.064000] ata_sg_clean: unmapping 1 sg elements
[17179886.064000] S90halt(4351): READ block 307632 on sda6
[17179886.064000] ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 07 5f 8e b0 00 00 08
[17179886.064000] ata_scsi_translate: ENTER
[17179886.064000] scsi_10_lba_len: ten-byte command
[17179886.064000] ata_sg_setup: ENTER, ata1
[17179886.064000] ata_sg_setup: 1 sg elements mapped
[17179886.064000] ata_fill_sg: PRD[0] = (0x7CC47000, 0x1000)
[17179886.064000] ata_dev_select: ENTER, ata1: device 0, wait 1
[17179886.064000] ata_tf_load_pio: feat 0x0 nsect 0x8 lba 0xB0 0x8E 0x5F
[17179886.064000] ata_tf_load_pio: device 0xE7
[17179886.064000] ata_exec_command_pio: ata1: cmd 0xC8
[17179886.064000] ata_scsi_translate: EXIT
[17179886.076000] ata_host_intr: ata1: host_stat 0x24
[17179886.076000] ata_host_intr: ata1: protocol 3 (dev_stat 0x50)
[17179886.076000] ata_sg_clean: unmapping 1 sg elements
