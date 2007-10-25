Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbXJYQ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbXJYQ5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXJYQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:57:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53564 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbXJYQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:57:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
Date: Thu, 25 Oct 2007 10:55:44 -0600
In-Reply-To: <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	(Thomas Gleixner's message of "Thu, 25 Oct 2007 18:09:49 +0200
	(CEST)")
Message-ID: <m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Thu, 25 Oct 2007, Huang, Ying wrote:
>
>> This patch adds basic runtime services support for EFI x86_64
>> system. The main file of the patch is the addition of efi.c for
>> x86_64. This file is modeled after the EFI IA32 avatar.
>
> modeled means copied and modified, right?
>
> This is wrong. I compared efi_32.c and efi_64.c and a large amount of
> the code is simply the same. The small details can be sorted out by
> two sets of macros/inline functions easily.
>
> Please fix this up.

I don't think there is a compelling case for us to use any efi
services at this time so unification should be easy:
rm arch/x86/kernel/efi_32.c arch/x86/kernel/efi_stub_32.c

Especially for accessing the real time clock that has a well
defined hardware interface going through efi an additional
software emulation layer looks like asking for trouble.

Eric



