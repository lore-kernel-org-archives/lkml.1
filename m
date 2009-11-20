Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZKTAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZKTAQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757772AbZKTAQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:16:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:14814 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194AbZKTAQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:16:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,773,1249282800"; 
   d="scan'208";a="748740270"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Thu, 19 Nov 2009 16:16:38 -0800
Subject: [PATCH 0/3] x86/pic: introduce legacy_pic abstraction
Thread-Topic: [PATCH 0/3] x86/pic: introduce legacy_pic abstraction
Thread-Index: Acppdroj2vfDrc5tSRmsUAHfe1u48g==
Message-ID: <43F901BD926A4E43B106BF17856F07558A00D90C@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is intended to allow runtime selection of legacy pic driver. it
decouples legacy pic code by replacing global function calls with an abstracted
legacy_pic structure.

.arch/x86/include/asm/hw_irq.h  |    7 ----
 arch/x86/include/asm/i8259.h   |   19 +++++++----
 arch/x86/include/asm/io_apic.h |    2 -
 arch/x86/kernel/apic/apic.c    |    8 ++--
 arch/x86/kernel/apic/io_apic.c |   67 +++++++++++++++++++---------------------
 arch/x86/kernel/apic/nmi.c     |    2 +-
 arch/x86/kernel/i8259.c        |   64 ++++++++++++++++++++++++++++++++++----
 arch/x86/kernel/irqinit.c      |    2 +-
 arch/x86/kernel/smpboot.c      |    5 ++-
 arch/x86/kernel/visws_quirks.c |   14 +++++---
 10 files changed, 119 insertions(+), 71 deletions(-)

