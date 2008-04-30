Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbYD3NdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbYD3NdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYD3NdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:33:09 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:54388 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761021AbYD3NdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:33:08 -0400
Date: Wed, 30 Apr 2008 10:31:43 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: bunk@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] iwlwifi: move the selects to the tristate drivers
Message-ID: <20080430133143.GA4679@beyonder.ift.unesp.br>
Mail-Followup-To: bunk@kernel.org, linux-kernel@vger.kernel.org
References: <20080428131552.GI16379@cs181133002.pp.htv.fi> <20080428142129.GA5679@beyonder.ift.unesp.br> <20080428205849.GB2813@cs181133002.pp.htv.fi> <20080429.223054.167583182.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429.223054.167583182.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29.Apr'08 at 22:30:54 -0700, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Mon, 28 Apr 2008 23:58:49 +0300
> 
> > This patch moves the following select's:
> > - RFKILL        : IWLWIFI_RFKILL -> IWLCORE
> > - RFKILL_INPUT  : IWLWIFI_RFKILL -> IWLCORE
> > - MAC80211_LEDS : IWL4965_LEDS   -> IWLCORE
> > - LEDS_CLASS    : IWL4965_LEDS   -> IWLCORE
> > - MAC80211_LEDS : IWL3945_LEDS   -> IWL3945
> > - LEDS_CLASS    : IWL3945_LEDS   -> IWL3945
> > 
> > The effects are:
> > - with IWLCORE=m and/or IWL3945=m RFKILL/RFKILL_INPUT/MAC80211_LEDS/LEDS_CLASS
> >   are no longer wrongly forced to y
> > - fixes a build error with IWLCORE=y, IWL4965=m
> >   might be a bug in kconfig causing it, but doing this change that is 
> >   anyway the right thing fixes it
> > 
> > Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Applied, thanks a lot Adrian.

Yeah Adrian, thank you very much!

It is really useful for the kernel to have someone like you cleaning 
up these Kconfig mistakes. My dumb patch was not good and now at 
least I know how it should be done.
Keep up your great work!

