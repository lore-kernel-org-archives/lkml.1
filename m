Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYIYIQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYIYIQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYIYIPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:15:46 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:37642 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752231AbYIYIPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:15:44 -0400
Date: Thu, 25 Sep 2008 10:15:40 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20080925081540.GA2305@anita>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924084846.GA2094@anita>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replying to myself...

Indeed my HArddisk was plugged into SATA2 and SATA1 was left empty, I
moved it to SATA1 now.

Am 2008-09-24 10:48 +0200 schrieb Konstantin Kletschke:

> Sep 24 07:12:47 zappa ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd808 irq 21
> Sep 24 07:12:47 zappa ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> Sep 24 07:12:47 zappa ata2.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
> Sep 24 07:12:47 zappa ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> Sep 24 07:12:47 zappa ata2.00: configured for UDMA/133

> Sep 21 11:34:57 zappa ata1: EH complete
> Sep 21 11:34:57 zappa ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> Sep 21 11:34:58 zappa ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
> Sep 21 11:34:58 zappa ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
> Sep 21 11:34:58 zappa ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t2

Now:

Sep 25 08:35:29 zappa ata1: SATA max UDMA/133 cmd 0xf80 ctl 0xf00 bmdma 0xd800 irq 21
Sep 25 08:35:29 zappa ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd808 irq 21
Sep 25 08:35:29 zappa ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep 25 08:35:29 zappa ata1.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
Sep 25 08:35:29 zappa ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Sep 25 08:35:29 zappa ata1.00: configured for UDMA/133


Sep 25 08:35:29 zappa ata2: EH pending after 5 tries, giving up
Sep 25 08:35:29 zappa ata2: EH complete
Sep 25 08:35:29 zappa ata2: EH pending after 5 tries, giving up
Sep 25 08:35:29 zappa ata2: EH complete

Kind REgards, Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
