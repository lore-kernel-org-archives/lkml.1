Return-Path: <linux-kernel-owner+w=401wt.eu-S934644AbXGLOig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644AbXGLOig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763731AbXGLOi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:38:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:21749 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762056AbXGLOi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:38:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,533,1175497200"; 
   d="scan'208";a="265359094"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][ACPI][BUTTON] remove procfs-interface
Date: Thu, 12 Jul 2007 10:38:23 -0400
Message-ID: <CFF307C98FEABE47A452B27C06B85BB60365D429@hdsmsx411.amr.corp.intel.com>
In-Reply-To: <1184235969.2415.0.camel@work>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][ACPI][BUTTON] remove procfs-interface
Thread-Index: AcfEb4dreMYZz3QYR8+NTZ2f4SU4OwAIrCzw
From: "Brown, Len" <len.brown@intel.com>
To: "Richard Hughes" <hughsient@gmail.com>, "Zhang, Rui" <rui.zhang@intel.com>
Cc: "Henne" <henne@nachtwindheim.de>, "Arjan van de Ven" <arjan@infradead.org>,
       <linux-acpi@vger.kernel.org>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Jul 2007 14:38:25.0651 (UTC) FILETIME=[4E041C30:01C7C492]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The last time I tried to remove this code,
we discovered that people were using it to query
the lid (button) status.

-Len 

>-----Original Message-----
>From: Richard Hughes [mailto:hughsient@gmail.com] 
>Sent: Thursday, July 12, 2007 6:26 AM
>To: Zhang, Rui
>Cc: Henne; Arjan van de Ven; Brown, Len; 
>linux-acpi@vger.kernel.org; akpm@linux-foundation.org; 
>linux-kernel@vger.kernel.org
>Subject: RE: [PATCH][ACPI][BUTTON] remove procfs-interface
>
>On Thu, 2007-07-12 at 17:46 +0800, Zhang, Rui wrote:
>> 
>> I'm not sure if the button sysfs I/F is already finished.
>> We'd better make a double check. :)
>
>We need a button sysfs interface? What's wrong with just using input?
>
>Richard.
>
