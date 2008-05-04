Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbYEDGZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbYEDGZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 02:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYEDGZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 02:25:29 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:45734 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYEDGZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 02:25:28 -0400
Date: Sat, 3 May 2008 23:25:27 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
cc: "Huang, Ying" <ying.huang@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
In-Reply-To: <20080429221225.GA5280@Chamillionaire.breakpoint.cc>
Message-ID: <alpine.DEB.1.10.0805032323580.27385@twinlark.arctic.org>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com> <20080416184016.GA21365@Chamillionaire.breakpoint.cc> <1208403403.4322.27.camel@caritas-dev.intel.com>
 <20080423223221.GB16683@Chamillionaire.breakpoint.cc> <1209093077.20936.24.camel@caritas-dev.intel.com> <20080429221225.GA5280@Chamillionaire.breakpoint.cc>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

one of the more important details in evaluating these changes would be the 
family/model/stepping of the processors being microbenchmarked... could 
you folks include /proc/cpuinfo with the results?

also -- please drop the #define for R16 to %rsp ... it obfuscates more 
than it helps anything.

thanks
-dean

On Wed, 30 Apr 2008, Sebastian Siewior wrote:

> * Huang, Ying | 2008-04-25 11:11:17 [+0800]:
> 
> >Hi, Sebastian,
> Hi Huang,
> 
> sorry for the delay.
> 
> >I changed the patches to group the read or write together instead of
> >interleaving. Can you help me to test these new patches? The new patches
> >is attached with the mail.
> The new results are attached.
> 
> >
> >Best Regards,
> >Huang Ying
> 
> Sebastian
> 
