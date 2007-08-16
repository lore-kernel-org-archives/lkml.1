Return-Path: <linux-kernel-owner+w=401wt.eu-S1765745AbXHPQKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765745AbXHPQKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761607AbXHPQJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:09:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759859AbXHPQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:09:53 -0400
Message-ID: <46C476C2.3020506@zytor.com>
Date: Thu, 16 Aug 2007 09:09:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com>	 <20070815161642.1bfbbe9c.akpm@linux-foundation.org>	 <46C38AA8.5040202@zytor.com> <1187251248.15063.12.camel@caritas-dev.intel.com>
In-Reply-To: <1187251248.15063.12.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> One question:
> 
> The boot_params.efi_info.efi_systab is defined as u32. But it should be
> u64 on x86_64, because it comes from firmware and is not controlled by
> bootloader. But, changing it from u32 to u64 will break current i386 EFI
> support, should we change it and fix the i386 EFI bootloader?
> 

The other option is to have a union of a 32-bit and a 64-bit structure.
 I personally don't care, as long as it's consistent, but I think you
need to deal with the people working on EFI currently about that...

	-hpa

