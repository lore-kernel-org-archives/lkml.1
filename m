Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZFTIWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZFTIWO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 04:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbZFTIVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 04:21:51 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42691 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbZFTIVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 04:21:48 -0400
To: Keir Fraser <keir.fraser@eu.citrix.com>
Cc: "Nakajima\, Jun" <jun.nakajima@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
References: <C66250DB.DC85%keir.fraser@eu.citrix.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 20 Jun 2009 01:21:47 -0700
In-Reply-To: <C66250DB.DC85%keir.fraser@eu.citrix.com> (Keir Fraser's message of "Sat\, 20 Jun 2009 08\:39\:55 +0100")
Message-ID: <m1ljnnnwmc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: keir.fraser@eu.citrix.com, lenb@kernel.org, tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xensource.com, jeremy@goop.org, jun.nakajima@intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Keir Fraser <keir.fraser@eu.citrix.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser <keir.fraser@eu.citrix.com> writes:

> On 20/06/2009 00:44, "Nakajima, Jun" <jun.nakajima@intel.com> wrote:
>
>>> I assume that putting AML into Xen has been considered, but I don't
>>> anything about those deliberations.  Keir? Jun?
>>> 
>> 
>> Yes, it was one of the options years ago. We did not do that because Linux and
>> Solaris (as dom0) already had the AML interpreter and it's overkill and
>> redundant to have such a large component in the Xen hypervisor. Since the
>> hypervisor does most of the power management (i.e. P, C, S-state, etc.)
>> getting the info from dom0 today, we might want to reconsider the option.
>
> Yes, we could reconsider. However is there any stuff that dom0 remains
> responsible for (e.g., PCI management, and therefore PCI hotplug) where it
> would continue to need to be OSPM, interpreting certain AML objects? In
> general how safe would it be to have two layered entities both playing at
> being OSPM?

Short of running the oddball acpi based drivers.  I'm not familiar with
any acpi in the pci management.

Eric

