Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXC1Pha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXC1Pha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXC1Pha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:37:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:13096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbXC1Ph3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:37:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,341,1170662400"; 
   d="scan'208"; a="65298455:sNHT25624089"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Date: Wed, 28 Mar 2007 08:37:27 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6EF989C9@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <m14po6w4n6.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Thread-Index: Acdw1oRmUkTRwEbETJClkRbhhYZyMgAeEzXw
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 28 Mar 2007 15:37:27.0552 (UTC) FILETIME=[FD5DD000:01C7714E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>The practical question in my book is do we set the enable/disable
>methods to the same functions as the mask/unmask methods or
>do we let them default to the crazy delayed disable scenario.
>
>Given that we do have a tiny race where we need to ensure the
>MSI is disabled before we unregister it, we don't know of any
>MSI implementation problems that will result in a screaming IRQ.
>I would say set enable/disable to the mask/unmask methods.
>

OK, that's easy.  I'll whip up a patch today, test it overnight,
and post it tomorrow.

Thanks for looking at this.

-Mitch
