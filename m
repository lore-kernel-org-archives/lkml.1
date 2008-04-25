Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYDYHQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYDYHQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYDYHQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:16:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:49782 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbYDYHQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,706,1199692800"; 
   d="scan'208";a="274597219"
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
From: "Huang, Ying" <ying.huang@intel.com>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <20080425071258.GA4460@Chamillionaire.breakpoint.cc>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
	 <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
	 <1208333949.4322.5.camel@caritas-dev.intel.com>
	 <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
	 <1208403403.4322.27.camel@caritas-dev.intel.com>
	 <20080423223221.GB16683@Chamillionaire.breakpoint.cc>
	 <1209093077.20936.24.camel@caritas-dev.intel.com>
	 <20080425071258.GA4460@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Apr 2008 15:21:27 +0800
Message-Id: <1209108087.20936.30.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 25 Apr 2008 07:16:32.0360 (UTC) FILETIME=[49D4F680:01C8A6A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sebastian,

On Fri, 2008-04-25 at 09:12 +0200, Sebastian Siewior wrote:
> * Huang, Ying | 2008-04-25 11:11:17 [+0800]:
> 
> >Hi, Sebastian,
> Hi Huang,
> 
> >So I think the reason maybe the read/write port throughput of CPU.
> Ah so it is just a local problem you say? I may get my fingers on
> another amd box....

I mean the read/write port design difference between CPU
micro-architecture. It is not a local problem. Sorry for my English.

> >I changed the patches to group the read or write together instead of
> >interleaving. Can you help me to test these new patches? The new patches
> >is attached with the mail.
> Sure.
Thank you very much.

Best Regards,
Huang Ying

