Return-Path: <linux-kernel-owner+w=401wt.eu-S1763983AbYD3SNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763983AbYD3SNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbYD3SNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:13:24 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:1503 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759479AbYD3SNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=X4XOtsHf3Kz4pgNlhUQ8YspxJuiHSoG5E4QjU2hPUAd5A6lehKDhbVNDKKt+iRFqhcGYop3R6L5Hkw2/ZFkSzPmJBGq3pOelVWVpDYdVUXrwuSXefBHJSE6WRXM15/eM/JHBh2RXkFYa00UyjYeqtOiGHOFE4EXeP2XiU2PqqS4=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: akpm@linux-foundation.org
Subject: IDE probe failure in 2.6.25-mm1
Date: Wed, 30 Apr 2008 23:43:14 +0530
User-Agent: KMail/1.9.9
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804302343.14949.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

IDE probe fails in 2.6.25-mm1 on qemu.

[    0.664164] Uniform Multi-Platform E-IDE driver
[    1.571508] ide0: DISABLED, NO IRQ
[    1.572380] ide0: failed to initialize IDE interface

This is the output with linux-2.6.git

[    1.567368] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.571430] hda: max request size: 512KiB
[    1.574302] hda: 10485760 sectors (5368 MB) w/256KiB Cache, CHS=10402/255/63
[    1.583896] hda: cache flushes supported
[    1.585053]  hda: hda1

This is apparently due to the invasive changes in hwif_t's io_ports member.

-- 
Warm Regards,

Balaji Rao
Dept. of Mechanical Engineering
NITK
