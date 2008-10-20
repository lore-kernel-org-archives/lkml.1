Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbYJTQ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbYJTQ7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYJTQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:59:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48991 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbYJTQ7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:59:12 -0400
Subject: Re: w35und wifi driver for linux-staging
From: Dan Williams <dcbw@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, kaszak@gmail.com, lcostantino@gmail.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <20081018141918.2c7377c6@infradead.org>
References: <20081001123656.GA30942@elf.ucw.cz>
	 <20081018141918.2c7377c6@infradead.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 12:57:54 -0400
Message-Id: <1224521874.29822.11.camel@dhcp-100-3-195.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-18 at 14:19 -0700, Arjan van de Ven wrote:
> On Wed, 1 Oct 2008 14:36:56 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > Hi!
> > 
> > This is driver for w35und usb wifi -- also in kohjinsha
> > subnotebook. It should work well enough to associate and ping, but it
> > obviously needs to be rewritten two more times...
> > 
> > OTOH worst horrors (like embedded wifi stack) should have been fixed
> > already...
> 
> > diff --git a/drivers/net/wireless/winbond/Kconfig
> > b/drivers/net/wireless/winbond/Kconfig new file mode 100644
> > index 0000000..94499d3
> > --- /dev/null
> > +++ b/drivers/net/wireless/winbond/Kconfig
> > @@ -0,0 +1,6 @@
> > +config W35UND
> > +	tristate "Winbond driver"
> > +	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
> > && !4KSTACKS
> 
> why this !4KSTACKS? At minimum that should be in the "to fix" list ;)

Yeah seriously, the driver isn't going anywhere unless it works with 4k
stacks...

Dan


