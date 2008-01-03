Return-Path: <linux-kernel-owner+w=401wt.eu-S1761093AbYACA6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093AbYACA6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbYACA6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:58:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:45594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095AbYACA6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:58:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,237,1196668800"; 
   d="scan'208";a="268515167"
Subject: Re: [PATCH -mm] EFI : Split EFI tables parsing code from EFI
	runtime service support code
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, tony.luck@intel.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071230142844.GM16946@elte.hu>
References: <1198910967.17317.47.camel@caritas-dev.intel.com>
	 <20071230142844.GM16946@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jan 2008 08:57:42 +0800
Message-Id: <1199321862.19248.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 03 Jan 2008 00:57:07.0078 (UTC) FILETIME=[8FFCDA60:01C84DA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-30 at 15:28 +0100, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > +struct efi_tables efi_tables;
> > +EXPORT_SYMBOL(efi_tables);
> 
> > +enum bios_type bios_type = BIOS_LEGACY;
> > +EXPORT_SYMBOL(bios_type);
> 
> please make all the new exports EXPORT_SYMBOL_GPL().

OK, I will change it.

Best Regards,
Huang Ying
