Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYGOUKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYGOUKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbYGOUKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:10:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:7306 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759166AbYGOUKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:10:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,368,1212390000"; 
   d="scan'208";a="598050001"
From: "Luck, Tony" <tony.luck@intel.com>
To: Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Tue, 15 Jul 2008 13:10:14 -0700
Subject: RE: [PATCH 00/14] Introduce cpu_enabled_map and friends
Thread-Topic: [PATCH 00/14] Introduce cpu_enabled_map and friends
Thread-Index: AcjmI0usawaLE1B1TSGx02qGyB76/AAkvwew
Message-ID: <57C9024A16AD2D4C97DC78E552063EA306594DA5@orsmsx505.amr.corp.intel.com>
References: <20080715023344.2528.1836.stgit@blender.achiang>
In-Reply-To: <20080715023344.2528.1836.stgit@blender.achiang>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6FKAvfq003405

> Patch 14 is the money patch. It demonstrates why we might
> want to go through all these gyrations. Now that ia64 presents
> *all* physically present CPUs in sysfs, even if they have been
> disabled by firmware, we give userspace a way to poke at those
> CPUs.

There's only the one bit for "disabled by firmware" ... no extra
space for any extra information.  How would userspace know that
it was safe to poke at a disabled cpu?  Perhaps firmware disabled
it for some very good reason, and poking at it could cause system
instability.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
