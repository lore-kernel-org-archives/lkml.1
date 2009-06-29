Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbZF2S5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbZF2S5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZF2S5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:57:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:16541 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZF2S5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,310,1243839600"; 
   d="scan'208";a="159712715"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Mon, 29 Jun 2009 11:57:45 -0700
Subject: RE: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Topic: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Index: Acn2uFQRXFCwfxmPQJ+HsGofaweP3QCMWaJg
Message-ID: <43F901BD926A4E43B106BF17856F0755641A4D19@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E8@orsmsx508.amr.corp.intel.com>
	<m1ab3ubx4q.fsf@fess.ebiederm.org>
	<43F901BD926A4E43B106BF17856F0755641A47CD@orsmsx508.amr.corp.intel.com>
 <m163eieey7.fsf@fess.ebiederm.org>
In-Reply-To: <m163eieey7.fsf@fess.ebiederm.org>
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

>Yes, completely separate out the 8259.  I believe that complete
>separation will come for free if you move the ioapic earlier.
>
>What kind of PIC is native?
>

[[JPAN]] the emulated IOAPIC is for the south complex, and north complex 
has true PCI MSI capability so it does not need an ioapic. There is no native
hw interrupt controller, all interrupts are forwarded by the FW and delivered
 to local APIC via FSB writes (kind of).

The programming interface for the emulated ioapic is compatiable but there are 
are some special "features" such as no special/legacy entries such as cascade 
i8259, hpet legacy replacement routes (2,8), etc.

I will add a more detail introduction in the next version of this patch set.
