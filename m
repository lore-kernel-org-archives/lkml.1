Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbZGUH65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbZGUH65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZGUH64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:58:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38199 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZGUH64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:58:56 -0400
Date: Tue, 21 Jul 2009 09:58:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: reinette chatre <reinette.chatre@intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: iwl3945: fix LED config option
Message-ID: <20090721075849.GA4133@elf.ucw.cz>
References: <20090619222431.GA2398@elf.ucw.cz> <1246298908.17896.391.camel@rc-desk> <20090709093859.GA10001@elf.ucw.cz> <1247153986.17896.1233.camel@rc-desk> <20090718102030.GA2040@elf.ucw.cz> <1248122730.17896.2582.camel@rc-desk> <20090720221914.GB28907@elf.ucw.cz> <1248145326.17896.2605.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248145326.17896.2605.camel@rc-desk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-07-20 20:02:06, reinette chatre wrote:
> Hi Pavel,
> 
> On Mon, 2009-07-20 at 15:19 -0700, Pavel Machek wrote:
> > > > diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
> > > > index e092af0..95d9aa5 100644
> > > > --- a/drivers/net/wireless/iwlwifi/Kconfig
> > > > +++ b/drivers/net/wireless/iwlwifi/Kconfig
> > > > @@ -9,6 +9,10 @@ config IWLWIFI
> > > >  config IWLWIFI_LEDS
> > > >  	bool "Enable LED support in iwlagn and iwl3945 drivers"
> > > >  	depends on IWLWIFI
> > > > +	default y
> > > 
> > > This is reasonable.
> > > 
> > > > +	---help---
> > > > +	  Useful to get Wifi LED working at least on Thinkpad notebooks.
> > > 
> > > I do not think this says more than what we already have. I actually
> > > think noting something about a particular platform will increase
> > > confusion (as in "so where is the option if I have an acer laptop?")
> > > because this option is needed to get LED support on all platforms. I do
> > > think what is currently written is sufficient, but if you insist on
> > > having some text there I think it should be simpler. Something like
> > > "Select this if you want LED support."
> > 
> > Sounds good. (I really believe it should have _some_ text). Will you
> > just modify/apply the patch, or should I resent?
> 
> Sure, I can take this patch and will send it through our usual route
> (via linux-wireless).

thanks!


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
