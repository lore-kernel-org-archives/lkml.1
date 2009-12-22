Return-Path: <linux-kernel-owner+w=401wt.eu-S1751628AbZLVXo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbZLVXo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbZLVXmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:42:07 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58135 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZLVXmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:42:02 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:40:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 0/25] x86: use early_res instead of bootmem before slab
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       "\"Yinghai Lu" <yingai@kernrel.org>
Message-id: <1261525263-13763-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yinghai Lu <yingai@kernrel.org>"

please check the patches regarding with early_res and bootmem

and at last it will make use early_res instead of bootmem with x86 64bits

the first two are needed for some amd_bus.c/intel_bus.c cleaning up patches too.
so put other x86/pci related into this series
hope that is ok to Jesse.

-v2: allocate vmemmap on one node together, and also seperate early_res

Thanks

Yinghai
