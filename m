Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXJaBK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXJaBK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXJaBKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:10:15 -0400
Received: from gw.goop.org ([64.81.55.164]:55630 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbXJaBKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:10:12 -0400
Message-ID: <4727D5F2.6000402@goop.org>
Date: Tue, 30 Oct 2007 18:10:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Fix boot protocol KEEP_SEGMENTS check.
References: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com> <200710311149.23006.rusty@rustcorp.com.au>
In-Reply-To: <200710311149.23006.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 27 October 2007 03:29:04 Eric W. Biederman wrote:
>   
>> The kernel only ever supports 1 version of the boot protocol
>> so there is no need to check the boot protocol revision to
>> see if a feature is supported.
>>     
>
> OK, I'm completely confused, so this is probably a v. dumb question.  Doesn't 
> this boot header come from the boot loader?

No, other way around.  It the kernel telling the bootloader "I
understand boot protocol X", and the bootloader makes sure it doesn't
fill out more than X allows.  If the bootloader supports <X, then the
kernel's boot_params structure is pre-constructed with reasonable
default values.

    J
