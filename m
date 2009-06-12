Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbZFLUfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbZFLUfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 16:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZFLUfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 16:35:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40891 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZFLUfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 16:35:42 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
References: <4A329CF8.4050502@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 12 Jun 2009 13:35:35 -0700
In-Reply-To: <4A329CF8.4050502@goop.org> (Jeremy Fitzhardinge's message of "Fri\, 12 Jun 2009 11\:22\:48 -0700")
Message-ID: <m1d499yyug.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Parse the ACPI MADT for I/O APIC information, even if the cpu has no
> (apparent) local APIC (ie, the CPU's APIC feature flag is clear).
>
> In principle, the local APIC and the I/O APIC are distinct (but related)
> components, which can be independently present.
>
> In practice this can happen in a Xen system, where the hypervisor has
> full control over the local APICs, and delivers interrupts initiated by
> the I/O APICs via Xen's event channel mechanism.

Xen  is giving us a semi bogus acpi table?

What is the paravirt configuration model with Xen?  Is it documented
somewhere?

Eric
