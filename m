Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYGXNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYGXNBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYGXNBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:01:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:41772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYGXNBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:01:08 -0400
Subject: Re: [RFC: 2.6 patch] clarify the WIRELESS_EXT_SYSFS help text
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080724124225.GD32109@cs181140183.pp.htv.fi>
References: <20080724115805.5466c217@mjolnir.drzeus.cx>
	 <1216899520.13587.49.camel@johannes.berg>
	 <20080724124225.GD32109@cs181140183.pp.htv.fi>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 14:54:48 +0200
Message-Id: <1216904088.7257.328.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 15:42 +0300, Adrian Bunk wrote:
> On Thu, Jul 24, 2008 at 01:38:40PM +0200, Johannes Berg wrote:
> > On Thu, 2008-07-24 at 11:58 +0200, Pierre Ossman wrote:
> > > From commit 22bb1be4d27...:
> > > 
> > > "The /sys/class/net/*/wireless/ direcory is, as far as I know, not used
> > > by anyone."
> > > 
> > > Can't have been much of an investigation as HAL uses these to determine
> > > if a card is a wireless one. Without this option, you cannot get
> > > wireless support in NetworkManager, stranding most laptops.
> > 
> > Bzzzzt. You suck. Go check again. Hint: try hal's git tree.
> 
> Can everyone agree on the patch below?
> 
> > johannes
> 
> cu
> Adrian
> 
> 
> <--  snip  -->
> 
> 
> Current Hal uses the CONFIG_WIRELESS_EXT_SYSFS files, so don't claim 
> there were no known users and recommend to enable the option.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> b685f62718b947264657c298e5ee5b2149200f68 
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index ab015c6..e582432 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -39,4 +39,4 @@ config WIRELESS_EXT_SYSFS
>  	  files in /sys/class/net/*/wireless/. The same information
>  	  is available via the ioctls as well.
>  
> -	  Say Y if you have programs using it (we don't know of any).
> +	  If unsure, say Y.

Maybe also add:

   "HAL <= 0.5.11 depends on this feature."

Where I hope I got the version number right :-)

