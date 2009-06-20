Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZFTKWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZFTKWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 06:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZFTKWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 06:22:41 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:55707 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZFTKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 06:22:41 -0400
X-IronPort-AV: E=Sophos;i="4.42,258,1243814400"; 
   d="scan'208";a="5824194"
User-Agent: Microsoft-Entourage/12.19.0.090515
Date: Sat, 20 Jun 2009 11:22:38 +0100
Subject: Re: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just
 because there's no local APIC
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: "Tian, Kevin" <kevin.tian@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>
Message-ID: <C66276FE.DC8E%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs
 just because there's no local APIC
Thread-Index: AcnxgECFuUm7zR6rT+uZmFUuvQQfLgAAHqXwAAQTeJc=
In-Reply-To: <0A882F4D99BBF6449D58E61AAFD7EDD62F1B68F3@pdsmsx502.ccr.corp.intel.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 20 Jun 2009 10:22:43.0235 (UTC) FILETIME=[0C19F730:01C9F191]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/2009 09:57, "Tian, Kevin" <kevin.tian@intel.com> wrote:

> So the real trouble is ACPI , which encode all platform bits if
> they're not included in any existing BUS spec, such as power,
> thermal, processor, battery, PCI routing, hotplug, EC, etc. Some
> are owned by dom0 and some by Xen. However ACPI's AML encoding
> makes automatic division between two categories really difficult.

Yes, we share the same lament regarding ACPI. I'm not sure what the best
(cleanest, simplest, whatever) solution really is going forward. We're
certainly happy to make quite fundamental changes in Xen if there is
sufficient win to be had.

 -- Keir


