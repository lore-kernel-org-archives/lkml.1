Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368Ab0ADDMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0ADDMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990Ab0ADDHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:07:20 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65035 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0ADDHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:14 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:04:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 0/29] x86: use early_res instead of bootmem before slab
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the patches regarding with early_res and bootmem

and at last it will use early_res instead of bootmem with x86 64bits

1-3 should be for 2.6.33

4 and 5: two are needed for some amd_bus.c/intel_bus.c cleaning up patches too.
so put other x86/pci related into this series, hope that is ok to Jesse.

-v2: allocate vmemmap on one node together, and also seperate early_res
-v3: make x86 32 bit support early_res to use bootmem too
     move related early_res to kernel/
     sparse vmemmap together: address Ingo.

Thanks

Yinghai
