Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYDCUpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYDCUpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 16:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbYDCUpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 16:45:14 -0400
Received: from archer.toppoint.de ([217.70.197.1]:54726 "EHLO mail.toppoint.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbYDCUpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 16:45:12 -0400
X-Greylist: delayed 1715 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 16:45:11 EDT
Date: Thu, 3 Apr 2008 22:05:29 +0200
From: Wilfried Klaebe <wk-20080331@kaos.in-kiel.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pozsar Balazs <pozsy@uhulinux.hu>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: suspend not working on macbook pro
Message-ID: <20080403200529.GA14399@kaos.in-kiel.de>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pozsar Balazs <pozsy@uhulinux.hu>, Pavel Machek <pavel@ucw.cz>,
	linux-kernel@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>,
	Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
References: <20080308110626.GE4491@ojjektum.uhulinux.hu> <200803211756.10987.rjw@sisk.pl> <20080403121035.GL29048@ojjektum.uhulinux.hu> <200804031711.56985.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804031711.56985.rjw@sisk.pl>
X-message-flag: Get yourself a real email client. http://www.mutt.org/
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, Apr 03, 2008 at 05:11:55PM +0200 schrieb Rafael J. Wysocki:
> On Thursday, 3 of April 2008, Pozsar Balazs wrote:
> > On Fri, Mar 21, 2008 at 05:56:10PM +0100, Rafael J. Wysocki wrote:
> > > On Friday, 21 of March 2008, Pozsar Balazs wrote:
> > > > On Sun, Mar 09, 2008 at 10:01:55AM +0100, Pavel Machek wrote:
> > > > > Hi!
> > > > > 
> > > > > > I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> > > > > > kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> > > > > > suspend. The console is still on, the disk is powered off, but no 
> > > > > > response or poweroff...
> > > > > > 
> > > > > > Did anyone else met the same thing? How could I help debug it?
> > > > > > What other info would you need?
> > > > > 
> > > > > Find more exact version when it broke? git bisect?
> > > > 
> > > > I did not have time for bisect, but I have found that if I boot an 
> > > > initrd and do not load the ata_piix module, suspend works, if I load it, 
> > > > it hangs during suspend.
> > > 
> > > Hm, we have an ata_piix vs suspend problem on this box, then.
> > > 
> > > Any chance to verify if 2.6.24.x works?
> > 
> > I tried with ata_piix.c copied from 2.6.24, and it fails the same way.
> 
> It generally is not sufficient to replace just one file.  Please try the entire
> 2.6.24.
> 
> Also, please check 2.6.25-rc8-git2, it might have fixed your issue.

I had the very same problems on a MacBook Pro 3.1 - 2.6.24 suspended and resumed,
2.6.25-rc[1-7] did not. I never had the time to bisect it, only to test newer RCs,
and 2.6.25-rc8 just works.

Thanks!

Wilfried
-- 
Irgendwas ist ja immer...
