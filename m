Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZFRT1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZFRT1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZFRT1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:27:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49414 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZFRT1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:27:43 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
References: <4A329CF8.4050502@goop.org>
	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
	<4A3A9220.4070807@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Jun 2009 12:27:39 -0700
In-Reply-To: <4A3A9220.4070807@goop.org> (Jeremy Fitzhardinge's message of "Thu\, 18 Jun 2009 12\:14\:40 -0700")
Message-ID: <m1zlc5jqac.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, lenb@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> On 06/18/09 09:08, Len Brown wrote:
>>> In principle, the local APIC and the I/O APIC are distinct (but related)
>>> components, which can be independently present.
>>>     
>>
>> bzzzzt, but thanks for playing:-)
>>   
>
> Perhaps I should have expressed that a bit more clearly:  you could, if
> mad, build a machine with I/O APICs and some other mechanism for
> delivering the interrupts to CPUs.  In practice, I doubt anyone ever
> has, or ever would.
>
> The only actual exception I know of is Xen's replacement of the physical
> local APIC with a paravirtualized interrupt interface.

No one ever has.  Xen doesn't have I/O APICs either.  Not in any real
sense.  Xen just has devices that looking like I/O apics if you don't
look close.

Eric

