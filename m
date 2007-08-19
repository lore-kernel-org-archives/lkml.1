Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbXHSW12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbXHSW12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXHSW1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:27:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60482 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbXHSW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:27:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	<20070815161642.1bfbbe9c.akpm@linux-foundation.org>
	<46C38AA8.5040202@zytor.com>
	<1187251248.15063.12.camel@caritas-dev.intel.com>
	<46C476C2.3020506@zytor.com>
Date: Sun, 19 Aug 2007 16:27:06 -0600
In-Reply-To: <46C476C2.3020506@zytor.com> (H. Peter Anvin's message of "Thu,
	16 Aug 2007 09:09:38 -0700")
Message-ID: <m1vebbqhxh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Huang, Ying wrote:
>> 
>> One question:
>> 
>> The boot_params.efi_info.efi_systab is defined as u32. But it should be
>> u64 on x86_64, because it comes from firmware and is not controlled by
>> bootloader. But, changing it from u32 to u64 will break current i386 EFI
>> support, should we change it and fix the i386 EFI bootloader?
>> 
>
> The other option is to have a union of a 32-bit and a 64-bit structure.
>  I personally don't care, as long as it's consistent, but I think you
> need to deal with the people working on EFI currently about that...

It sounds like the 64bit EFI is currently binary incompatible with
the 32bit EFI.

Eric
