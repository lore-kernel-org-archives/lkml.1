Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZFSFvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZFSFvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 01:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZFSFvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 01:51:08 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39758 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZFSFvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 01:51:07 -0400
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "the arch\/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
References: <4A329CF8.4050502@goop.org>
	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
	<4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>
	<4A3A99FB.7070807@goop.org> <m1vdmtgtt2.fsf@fess.ebiederm.org>
	<4A3AC0C4.6060508@goop.org>
	<86802c440906182232r31088e4fh3613a8da6f8903f7@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Jun 2009 22:50:59 -0700
In-Reply-To: <86802c440906182232r31088e4fh3613a8da6f8903f7@mail.gmail.com> (Yinghai Lu's message of "Thu\, 18 Jun 2009 22\:32\:59 -0700")
Message-ID: <m1fxdwdb5o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: yhlu.kernel@gmail.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, lenb@kernel.org, jeremy@goop.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's  no local APIC
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> doesn't XEN support per cpu irq vector?

Nope.  It doesn't even support the notion of cpus.

Eric
