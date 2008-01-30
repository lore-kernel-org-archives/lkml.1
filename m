Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYA3SfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYA3SfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYA3SfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:35:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:35378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbYA3SfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:35:07 -0500
From: Andi Kleen <ak@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: ioremap_xxx() with EXEC enabled
Date: Wed, 30 Jan 2008 19:35:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <1201685530.17912.11.camel@caritas-dev.intel.com> <20080130173048.GA9812@bingen.suse.de> <20080130094427.720fdae7@laptopd505.fenrus.org>
In-Reply-To: <20080130094427.720fdae7@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801301935.39069.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 1) 32 bit EFI is totally irrelevant.

Apparently not to the original poster. And some Apple x86 users might 
also disagree.

On x86-64 BTW while they could still rely on end_pfn_mapped and
it being direct mapped Venki's PAT patchkit removes that so ioremap
would be needed there too 

> 2) set_memory_ and set_pages_ API is not restricted to direct mapping.
> That's why they take a virtual address / struct page

If there is no direct mapping what page tables should they change?
Surely you're not suggesting they should walk all vmalloc areas and switch
them over. I don't think this is correct.

-Andi
