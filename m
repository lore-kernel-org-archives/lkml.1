Return-Path: <linux-kernel-owner+w=401wt.eu-S964844AbYDWBC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbYDWBC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbYDWBCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:02:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:54538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547AbYDWBCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,696,1199692800"; 
   d="scan'208";a="555885179"
Subject: Re: [PATCH] PCI Express ASPM support should default to 'No'
From: Shaohua Li <shaohua.li@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <200804221712.45972.jbarnes@virtuousgeek.org>
References: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com>
	 <200804221712.45972.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 09:05:21 +0800
Message-Id: <1208912721.31625.3.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-22 at 17:12 -0700, Jesse Barnes wrote:
> On Tuesday, April 22, 2008 3:28 pm Jesper Juhl wrote:
> > Running 'make oldconfig' I just noticed that PCIEASPM defaults to
> > 'y' in Kconfig even though the feature is both experimental and the
> > help text recommends that if you are unsure you say 'n'.
> > It seems to me that this really should default to 'n', not 'y' at the
> > moment.
> > The following patch makes that change. Please consider applying.
> 
> Seem reasonable, Shaohua?  Please cc linux-pci on PCI patches
> though...
Ok, I'm fine with the patch. Though by default, the policy is to use
BIOS setting, that is if BIOS disables ASPM, we don't enable it too.

Thanks,
Shaohua

