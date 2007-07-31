Return-Path: <linux-kernel-owner+w=401wt.eu-S969662AbXGaEsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969662AbXGaEsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761667AbXGaEse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:48:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49271 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbXGaEsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:48:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86_64 EFI support -v3
References: <1185851569.23149.25.camel@caritas-dev.intel.com>
Date: Mon, 30 Jul 2007 22:47:14 -0600
In-Reply-To: <1185851569.23149.25.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Tue, 31 Jul 2007 11:12:49 +0800")
Message-ID: <m1myxdtc19.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> Looking forward to your comments,

After reading through the patches.  I don't see any compelling
reason to use the efi runtime support.  It looks like we get
the interesting support for efi without out.  The graphics
and the memory map.  We have ACPI which already can do handle
this case.

Further the code has dead code sitting in the patches that you never
intend to use. EFI_MEMMAP.

The boot protocols are now out of sync for arch/i386 and arch/x86_64
for no obvious reason.

Using efi_set_virtual means kdump doesn't work which means that no
one is going to use this in a prebuilt kernel.

So mostly this patchset looks like a bad idea.

Eric
