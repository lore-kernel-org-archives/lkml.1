Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZFRTOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZFRTOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZFRTOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:14:45 -0400
Received: from claw.goop.org ([74.207.240.146]:38001 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZFRTOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:14:45 -0400
Message-ID: <4A3A9220.4070807@goop.org>
Date: Thu, 18 Jun 2009 12:14:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org> <alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/09 09:08, Len Brown wrote:
>> In principle, the local APIC and the I/O APIC are distinct (but related)
>> components, which can be independently present.
>>     
>
> bzzzzt, but thanks for playing:-)
>   

Perhaps I should have expressed that a bit more clearly:  you could, if
mad, build a machine with I/O APICs and some other mechanism for
delivering the interrupts to CPUs.  In practice, I doubt anyone ever
has, or ever would.

The only actual exception I know of is Xen's replacement of the physical
local APIC with a paravirtualized interrupt interface.

    J
