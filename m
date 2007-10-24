Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbXJXB5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbXJXB5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbXJXB50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:57:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbXJXB50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:57:26 -0400
Message-ID: <471EA67C.7010401@zytor.com>
Date: Tue, 23 Oct 2007 18:57:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 boot: document for 32 bit boot protocol
References: <1193190817.23935.108.camel@caritas-dev.intel.com>
In-Reply-To: <1193190817.23935.108.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patch documents the 32-bit boot protocol of x86. It has been used
> by Kexec and LinuxBIOS. This patch is based on the proposal of Peter
> Anvin.

> +At entry, the CPU must be in 32-bit protected mode with paging
> +disabled; a GDT must be loaded with the descriptors for selectors
> +__BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
> +segment; __BOOS_CS must have execute/read permission, and __BOOT_DS
> +must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
> +must be __BOOT_DS; interrupt must be disabled; %esi must hold the base
> +address of the struct boot_params; %ebp, %edi must be zero.

You missed the (ironically the only one currently existing) constraint 
that %ebx must be zero.

	-hpa
