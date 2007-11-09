Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbXKJAFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbXKJAFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 19:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbXKJAEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 19:04:52 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:45320 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbXKJAEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 19:04:51 -0500
X-Greylist: delayed 1942 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2007 19:04:50 EST
Date: Sat, 10 Nov 2007 00:32:15 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Mark Lord <liml@rtr.ca>,
       Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071109233215.GA22498@citd.de>
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109120425.543971bf@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.2007 12:04, Alan Cox wrote:
> On Thu, 8 Nov 2007 22:46:22 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
> 
> > On Thu, Nov 08, 2007 at 10:29:37PM -0500, Mark Lord wrote:
> > > And I might even privately patch my own kernels to map the ACHI BAR
> > > in the cases where the BIOS didn't...
> > 
> > The inability to do this in the general case is the main reason why
> > AHCI was not unconditionally enabled, even in IDE mode, when it was
> > originally added...  :/
> 
> We've done it all the time for various devices without problems (eg S3
> video cards). I'd like to see it go in - although perhaps attached to a
> force_ahci boot param initially

I second that.

My computer/mainboard @work has such a "broken" BIOS. Of the 5 
SATA-Ports this MB has only 1 (and 1 "missing" that is reported by linux 
but i can't find on the MB) is configured as AHCI which means that with 
a HDD & a DVD-ROM connected to 2 of the 4 "piix"-ports, i only have 1 
hot-pluggable port instead of the possible 3. And for some temporary 
work i would really need at least 2 hot-pluggable ports.

So as a work-around i will try a Promise 150 TX4 controller as it is 
supposed to support hotplug since 2.6.23.

After having hotplug @home from the date the linux-kernel supporting it 
was released, i don't want to live without it, as i use it daily.


And on the topic of "broken" BIOSes. I have a little empathy for the MB 
manufactures as non-RAID AHCI royaly screws Windos, so not supporting it 
reduces their support costs enough to overlook screwing the non-windos 
faction.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

