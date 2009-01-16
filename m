Return-Path: <linux-kernel-owner+w=401wt.eu-S934116AbZAPNkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbZAPNkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765066AbZAPNkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:40:46 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54462 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763900AbZAPNkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:40:45 -0500
Message-Id: <49709C94.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 16 Jan 2009 13:41:24 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: fully honor "nolapic" (take 2)
References: <4970818A.76E4.0078.0@novell.com>
 <20090116124548.GC5421@elte.hu>
In-Reply-To: <20090116124548.GC5421@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 16.01.09 13:45 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> +	if (disable_apic) {
>> +#ifdef CONFIG_X86_IO_APIC
>> +		disable_ioapic_setup();
>> +#endif
>> +		return;
>> +	}
>
>Shouldnt that #ifdef be avoided by always providing the function - just it 
>is a NOP inline in the !CONFIG_X86_IO_APIC case?

That would make for a much bigger patch, since the io_apic.h doesn't
(and imo shouldn't) be included without that config option.

Jan

