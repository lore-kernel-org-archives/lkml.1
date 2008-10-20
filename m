Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbYJTRdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbYJTRdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYJTRcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:32:50 -0400
Received: from kroah.org ([198.145.64.141]:45260 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752886AbYJTRct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:32:49 -0400
Date: Mon, 20 Oct 2008 10:27:50 -0700
From: Greg KH <greg@kroah.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und wifi driver for linux-staging
Message-ID: <20081020172750.GA9587@kroah.com>
References: <20081001123656.GA30942@elf.ucw.cz> <20081018141918.2c7377c6@infradead.org> <1224521874.29822.11.camel@dhcp-100-3-195.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224521874.29822.11.camel@dhcp-100-3-195.bos.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 12:57:54PM -0400, Dan Williams wrote:
> On Sat, 2008-10-18 at 14:19 -0700, Arjan van de Ven wrote:
> > On Wed, 1 Oct 2008 14:36:56 +0200
> > Pavel Machek <pavel@suse.cz> wrote:
> > 
> > > Hi!
> > > 
> > > This is driver for w35und usb wifi -- also in kohjinsha
> > > subnotebook. It should work well enough to associate and ping, but it
> > > obviously needs to be rewritten two more times...
> > > 
> > > OTOH worst horrors (like embedded wifi stack) should have been fixed
> > > already...
> > 
> > > diff --git a/drivers/net/wireless/winbond/Kconfig
> > > b/drivers/net/wireless/winbond/Kconfig new file mode 100644
> > > index 0000000..94499d3
> > > --- /dev/null
> > > +++ b/drivers/net/wireless/winbond/Kconfig
> > > @@ -0,0 +1,6 @@
> > > +config W35UND
> > > +	tristate "Winbond driver"
> > > +	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
> > > && !4KSTACKS
> > 
> > why this !4KSTACKS? At minimum that should be in the "to fix" list ;)
> 
> Yeah seriously, the driver isn't going anywhere unless it works with 4k
> stacks...

Well, it's going into the staging tree, where it can now be fixed up :)

And yes, I'll go add that to the TODO list for this driver, thanks.

greg k-h
