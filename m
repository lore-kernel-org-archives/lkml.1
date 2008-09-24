Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbYIXItD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbYIXItD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYIXIsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:48:51 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:40277 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753834AbYIXIsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:48:50 -0400
Date: Wed, 24 Sep 2008 10:48:46 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20080924084846.GA2094@anita>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D89C85.2080104@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-09-23 10:36 +0300 schrieb Benny Halevy:

> are printed for a disconnected ATA port that's a neighbor
> of one that's occupied.

Hey, I did not realize this yet!

My only SATA device seems to be connected to Port2:

Sep 24 07:12:47 zappa ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd808 irq 21
Sep 24 07:12:47 zappa ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep 24 07:12:47 zappa ata2.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
Sep 24 07:12:47 zappa ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Sep 24 07:12:47 zappa ata2.00: configured for UDMA/133

Whereas my message log is still flooded by ata1 stuff:

Sep 21 11:34:57 zappa ata1: EH complete
Sep 21 11:34:57 zappa ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Sep 21 11:34:58 zappa ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
Sep 21 11:34:58 zappa ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
Sep 21 11:34:58 zappa ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t2

Tijo, is there any stuff I should try out? I mean, if I got this right,
the boot problems itself were fixed by removing nv_hardreset, but is
there a way around getting the log flooded by "EH complete" now?


Kind regards, Konsti



-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
