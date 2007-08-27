Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbXH0S0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbXH0S0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXH0S0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:26:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:36963 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbXH0S0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:26:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,313,1183359600"; 
   d="scan'208";a="122201791"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] kexec: reenable HPET before kexec
Date: Mon, 27 Aug 2007 11:26:29 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F501522051@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070827053656.GC9809@in.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] kexec: reenable HPET before kexec
Thread-Index: AcfobIVkqr+5k7OyTvmaKGzhzp8BNQAawcDg
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru> <20070823090845.GA13065@in.ibm.com> <20070823154936.3b7ae498@windmill.dev.rtsoft.ru> <20070827053656.GC9809@in.ibm.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: <vgoyal@in.ibm.com>, "Konstantin Baydarov" <kbaidarov@ru.mvista.com>
Cc: "RT" <linux-rt-users@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Andi Kleen" <ak@suse.de>
X-OriginalArrivalTime: 27 Aug 2007 18:26:31.0219 (UTC) FILETIME=[CA409030:01C7E8D7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>
>I think we should dive little deeper to find out the root 
>cause of the problem
>instead of putting the intermediate patch. These timer issues 
>are tricky
>ones and we have already solved few of these.
>
>Going back to your original mail where you specify root cause.
>
>- You mentioned that first kernel disables HPET while enabling 
>Local APIC
>timer. Can you please point me when exactly it happens. I had 
>thought local
>APIC timer and HPET server different purpose and co-exist.
>
>- You also mentioned that kernel tries to setup PIT as it does not find
>HPET in second kernel. Where exactly does it do that? I think 
>we need to
>then go deeper to find out why PIT is not working now? Is it 
>disabled? or
>LAPIC/IOAPIC have not been setup properly and PIT interrupts 
>never reach
>CPU? 
>

- Another thing to try is to disable HPET and boot with PIT in the first
kernel. Just to check whether PIT never works on this platform or the
first kernel is doing something to stop PIT. You can try "hpet=disable"
boot option for that.

Thanks,
Venki
