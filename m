Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZFSXoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZFSXoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZFSXoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:44:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:25646 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZFSXoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:44:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,256,1243839600"; 
   d="scan'208";a="468013077"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Keir Fraser <keir.fraser@eu.citrix.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>
Date: Fri, 19 Jun 2009 16:44:24 -0700
Subject: RE: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs
 just because there's no local APIC
Thread-Topic: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs
 just because there's no local APIC
Thread-Index: AcnxGFURHFiqpoaUQU+zperNWcAO4AAFye+w
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A188656507@orsmsx505.amr.corp.intel.com>
References: <4A329CF8.4050502@goop.org>
	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
	<4A3A9220.4070807@goop.org>	<m1zlc5jqac.fsf@fess.ebiederm.org>
	<4A3A99FB.7070807@goop.org>	<m1vdmtgtt2.fsf@fess.ebiederm.org>
	<4A3AC0C4.6060508@goop.org>	<m17hz9djwn.fsf@fess.ebiederm.org>
 <4A3BEDD6.6070303@goop.org>
In-Reply-To: <4A3BEDD6.6070303@goop.org>
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

Jeremy Fitzhardinge wrote on Fri, 19 Jun 2009 at 12:58:14:

>> 
>> Which if dom0 is to be redundant/restartable seems to make the
>> argument for AML living in Xen.
>> 
>> Xen has everything except the AML interpreter.
>> 
> 
> I assume that putting AML into Xen has been considered, but I don't
> anything about those deliberations.  Keir? Jun?
> 

Yes, it was one of the options years ago. We did not do that because Linux and Solaris (as dom0) already had the AML interpreter and it's overkill and redundant to have such a large component in the Xen hypervisor. Since the hypervisor does most of the power management (i.e. P, C, S-state, etc.) getting the info from dom0 today, we might want to reconsider the option. 

Jun
___
Intel Open Source Technology Center


