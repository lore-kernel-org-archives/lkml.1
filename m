Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbXGaGff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbXGaGff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 02:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXGaGf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 02:35:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:21944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbXGaGf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 02:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,201,1183359600"; 
   d="scan'208";a="256747911"
Subject: Re: [PATCH 4/5] x86_64 EFI support -v3: EFI framebuffer driver
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@pol.net>, linux-kernel@vger.kernel.org
In-Reply-To: <m1zm1dtcmz.fsf@ebiederm.dsl.xmission.com>
References: <1185851582.23149.29.camel@caritas-dev.intel.com>
	 <m1zm1dtcmz.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 14:35:08 +0800
Message-Id: <1185863708.23149.46.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 06:35:19.0172 (UTC) FILETIME=[F693AC40:01C7D33C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 22:34 -0600, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > This patch adds Graphics Output Protocol support to the kernel.
> > UEFI2.0 spec deprecates Universal Graphics Adapter (UGA) protocol and
> > only Graphics Output Protocol (GOP) is produced. Therefore, the boot
> > loader needs to query the UEFI firmware with appropriate Output
> > Protocol and pass the video information to the kernel. As a result of
> > GOP protocol, an EFI framebuffer driver is needed for displaying
> > console messages. The patch adds a EFI framebuffer driver. The EFI
> > frame buffer driver in this patch is based on the Intel Mac
> > framebuffer driver.
> >
> > The ELILO bootloader takes care of passing the video information as
> > appropriate for EFI firmware.
> 
> Am I correct in understanding that you are not using any of the efi
> runtime service infrastructure you have built up in other patches?

Yes. The EFI runtime service is not needed for this patch.

Best Regards,
Huang Ying
