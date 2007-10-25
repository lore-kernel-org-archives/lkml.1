Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXJYWWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXJYWWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXJYWWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:22:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37443 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbXJYWWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:22:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	<m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
	<20071025095639.22f6cad0@laptopd505.fenrus.org>
	<4720CCBC.1050700@zytor.com>
	<m1y7dr3xha.fsf@ebiederm.dsl.xmission.com>
	<4720D797.1020903@zytor.com>
	<m1tzof3wbk.fsf@ebiederm.dsl.xmission.com>
	<4720FE38.3050802@zytor.com>
Date: Thu, 25 Oct 2007 16:20:20 -0600
In-Reply-To: <4720FE38.3050802@zytor.com> (H. Peter Anvin's message of "Thu,
	25 Oct 2007 13:36:08 -0700")
Message-ID: <m1lk9q4z17.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>>>
>>> Ying claimed that GOP requires EFI runtime services.  Is that not true?
>>
>> None of the EFI framebuffer patches that I saw used EFI runtime services.
>>
>
> Ying, could you please clarify this situation?
>
> (Eric: do note that there are two EFI framebuffer standard, UGA and
> GOP. Apparently UGA is obsolete and we have always been at war with GOP at the
> moment.)


Peter please look back in your email archives to yesterday and
see Ying's patch:

[PATCH 1/2 -v2 resend] x86_64 EFI boot support: EFI frame buffer driver

All of the data the GOP needs is acquired through the a query made
by the bootloader and passed through screen info.

Eric
