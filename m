Return-Path: <linux-kernel-owner+w=401wt.eu-S969524AbXGaElq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969524AbXGaElq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968749AbXGaEfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:35:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54542 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968116AbXGaEfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:35:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@pol.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86_64 EFI support -v3: EFI framebuffer driver
References: <1185851582.23149.29.camel@caritas-dev.intel.com>
Date: Mon, 30 Jul 2007 22:34:12 -0600
In-Reply-To: <1185851582.23149.29.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Tue, 31 Jul 2007 11:13:02 +0800")
Message-ID: <m1zm1dtcmz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> This patch adds Graphics Output Protocol support to the kernel.
> UEFI2.0 spec deprecates Universal Graphics Adapter (UGA) protocol and
> only Graphics Output Protocol (GOP) is produced. Therefore, the boot
> loader needs to query the UEFI firmware with appropriate Output
> Protocol and pass the video information to the kernel. As a result of
> GOP protocol, an EFI framebuffer driver is needed for displaying
> console messages. The patch adds a EFI framebuffer driver. The EFI
> frame buffer driver in this patch is based on the Intel Mac
> framebuffer driver.
>
> The ELILO bootloader takes care of passing the video information as
> appropriate for EFI firmware.

Am I correct in understanding that you are not using any of the efi
runtime service infrastructure you have built up in other patches?

So far this looks like the only useful piece of the patchset.
If this doesn't use the runtime services I don't see any point
in having them.

Eric
