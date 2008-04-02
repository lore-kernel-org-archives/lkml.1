Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYDBNYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYDBNYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 09:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYDBNYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 09:24:34 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:14056 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbYDBNYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:24:33 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-ide@vger.kernel.org
Subject: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Wed, 2 Apr 2008 15:24:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021524.27222.elendil@planet.nl>
X-OriginalArrivalTime: 02 Apr 2008 13:24:29.0582 (UTC) FILETIME=[E16172E0:01C894C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've received an installation report for Debian for an older system where
no IDE driver gets loaded. The system does not have any IDE device listed in
lspci. When ide-generic is modprobed manually, both the CD and hard disk
work fine.

Any suggestions on how such a system could be recognized?
If we could do that, the installation system could take responsibility for
loading ide-generic and making sure it is included in the initrd.

Or even better, any chance to make the kernel/udev load ide-generic
automatically for this system?

See http://bugs.debian.org/472487 for details. I can get additional info
from the owner of the system if needed.

Cheers,
FJP

Output of lspci -nn:
00:00.0 Host bridge [0600]: Toshiba America Info Systems CPU to PCI bridge [1179:0601] 
(rev a0)
00:04.0 VGA compatible controller [0300]: Chips and Technologies F65555 HiQVPro 
[102c:00e5] (rev c6)
00:0b.0 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 02)
00:11.0 Communication controller [0780]: Toshiba America Info Systems FIR Port 
[1179:0701] (rev 21)
00:13.0 CardBus bridge [0607]: Toshiba America Info Systems ToPIC97 [1179:060f] (rev 
20)
00:13.1 CardBus bridge [0607]: Toshiba America Info Systems ToPIC97 [1179:060f] (rev 
20)
