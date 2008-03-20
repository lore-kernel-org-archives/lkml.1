Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYCTJN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYCTJN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 05:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbYCTJNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 05:13:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:50659 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbYCTJNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 05:13:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,530,1199692800"; 
   d="scan'208";a="536899543"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Xen common code across architecture
Date: Thu, 20 Mar 2008 17:13:43 +0800
Message-ID: <10EA09EFD8728347A513008B6B0DA77A02EF8C3A@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <12047411473158-git-send-email-yamahata@valinux.co.jp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Xen common code across architecture
Thread-Index: Ach+7bilScqNQx56TrWtkr1yygdDlQLe4sPQ
References: <12047411453864-git-send-email-yamahata@valinux.co.jp> <12047411473158-git-send-email-yamahata@valinux.co.jp>
From: "Dong, Eddie" <eddie.dong@intel.com>
To: <virtualization@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Cc: <kvm-ia64-devel@lists.sourceforge.net>,
       <xen-ia64-devel@lists.xensource.com>, <linux-ia64@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 20 Mar 2008 09:13:47.0234 (UTC) FILETIME=[B4128C20:01C88A6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy & all:
	Current xen kernel codes are in arch/x86/xen, but xen dynamic
irqchip (events.c) are common for other architectures such as IA64. We
are in progress with enabling pv_ops for IA64 now and want to reuse same
code, do we need to move the code to some place common? suggestions?
	Thanks, eddie
