Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZFZVmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZFZVmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 17:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZFZVl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 17:41:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:4292 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZFZVl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 17:41:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,298,1243839600"; 
   d="scan'208";a="702894676"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 26 Jun 2009 14:41:57 -0700
Subject: RE: [PATCH 8/9] x86/apic: match destination id with destination mode
Thread-Topic: [PATCH 8/9] x86/apic: match destination id with destination
 mode
Thread-Index: Acn2pCNgFItYTw2fQAqq6XhW4KIKIwAAlC8g
Message-ID: <43F901BD926A4E43B106BF17856F0755641A4717@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E7@orsmsx508.amr.corp.intel.com>
 <86802c440906261421g77fd0e50j7dfdbbdcc7c0b8eb@mail.gmail.com>
In-Reply-To: <86802c440906261421g77fd0e50j7dfdbbdcc7c0b8eb@mail.gmail.com>
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

>so this patch will put all ioapic routing to boot_cpu_id what is that?
>how can you assume that is is apic id.?
>that is NOT apic id.
[[JPAN]] I don't know a better way to assign physical APIC IDs. Any suggestions?
At least giving boot_cpu_id would prevent system to crash( when you have logical 
ID assigned as physical).

