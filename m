Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbYBRKuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbYBRKuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbYBRKu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:50:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58864 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbYBRKuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:50:25 -0500
Date: Mon, 18 Feb 2008 12:26:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       torvalds@osdl.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080218112621.GA24147@one.firstfloor.org>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu> <1203050886.30010.19.camel@caritas-dev.intel.com> <20080215070843.GA6975@elte.hu> <1203299636.27509.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203299636.27509.14.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After looking up in UEFI specification, I found that it is specified by

Thanks.

> UEFI specification 2.1 (section 6.2, page 124) that the NumberOfPages
> (num_pages) of EFI_MEMORY_DESCRIPTOR (efi_memory_desc_t) must be "Number
> of 4KB pages in the memory region". So we need not worry about potential
> EFI_PAGE_SHIFT changes.

Then it would be cleaner to just use PAGE_SIZE in the x86 specific EFI
code imho.

-Andi
