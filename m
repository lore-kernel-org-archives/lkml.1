Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZFTHkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZFTHkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 03:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZFTHkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 03:40:01 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:2289 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZFTHkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 03:40:00 -0400
X-IronPort-AV: E=Sophos;i="4.42,258,1243814400"; 
   d="scan'208";a="5823484"
User-Agent: Microsoft-Entourage/12.19.0.090515
Date: Sat, 20 Jun 2009 08:39:55 +0100
Subject: Re: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just
 because there's no local APIC
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: "Nakajima, Jun" <jun.nakajima@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Message-ID: <C66250DB.DC85%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs
 just because there's no local APIC
Thread-Index: AcnxGFURHFiqpoaUQU+zperNWcAO4AAFye+wABK0Pns=
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A188656507@orsmsx505.amr.corp.intel.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 20 Jun 2009 07:40:02.0719 (UTC) FILETIME=[52616AF0:01C9F17A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/2009 00:44, "Nakajima, Jun" <jun.nakajima@intel.com> wrote:

>> I assume that putting AML into Xen has been considered, but I don't
>> anything about those deliberations.  Keir? Jun?
>> 
> 
> Yes, it was one of the options years ago. We did not do that because Linux and
> Solaris (as dom0) already had the AML interpreter and it's overkill and
> redundant to have such a large component in the Xen hypervisor. Since the
> hypervisor does most of the power management (i.e. P, C, S-state, etc.)
> getting the info from dom0 today, we might want to reconsider the option.

Yes, we could reconsider. However is there any stuff that dom0 remains
responsible for (e.g., PCI management, and therefore PCI hotplug) where it
would continue to need to be OSPM, interpreting certain AML objects? In
general how safe would it be to have two layered entities both playing at
being OSPM?

 -- Keir


