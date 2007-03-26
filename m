Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbXCZUBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbXCZUBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbXCZUBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:01:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:42053 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbXCZUBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:01:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,330,1170662400"; 
   d="scan'208"; a="64230078:sNHT17556867"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Mon, 26 Mar 2007 13:01:05 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0148323B@scsmsx411.amr.corp.intel.com>
In-Reply-To: <m1fy7u3sas.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [3/5] 2.6.21-rc4: known regressions (v2)
Thread-Index: Acduj0iIjSYwd5aYQEKIHYS+sMx/tgBUYsFw
From: "Luck, Tony" <tony.luck@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Meyer" <thomas@m3y3r.de>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
X-OriginalArrivalTime: 26 Mar 2007 20:01:06.0843 (UTC) FILETIME=[7D928EB0:01C76FE1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What I'm proposing we do is move the irq allocation code out of
> pci_enable_device and the irq freeing code out of pci_disable_device
> in the future.

Sounds rational ... in a world that wasn't dominated by PCI it would
seem to be the logical approach (since the irq code would have much
more utility independent of the PCI code).

> Tony, Len before we merge any fixes for 2.6.21-rcX I'd like to at
> least get an ack on the long term direction.

Long-term-direction-acked-by: Tony Luck <tony.luck@intel.com>

-Tony
