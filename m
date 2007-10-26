Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXJZLkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXJZLkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXJZLkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:40:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:54131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbXJZLkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:40:10 -0400
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic runtime service support
Date: Fri, 26 Oct 2007 13:37:02 +0200
User-Agent: KMail/1.9.1
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <1193295473.23935.202.camel@caritas-dev.intel.com> <1193360591.23935.212.camel@caritas-dev.intel.com> <alpine.LFD.0.9999.0710261027260.3186@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710261027260.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710261337.03465.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I still do not understand why we need all this EFI hackery at all
> aside of the possible usage for saving a crash dump on FLASH, which we
> could do directly from the kernel as well.

Battery backed up RAM not Flash. The layout of that RAM is BIOS dependent so 
we need some BIOS support for change it. Essentially it's a way to put 
something into the BIOS event log.

-Andi
