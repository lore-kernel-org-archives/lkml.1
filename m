Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYDGV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYDGV3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYDGV3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:29:25 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:35718 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYDGV3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:29:24 -0400
Date: Mon, 7 Apr 2008 23:29:22 +0200
From: Pozsar Balazs <pozsy@uhulinux.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: suspend not working on macbook pro
Message-ID: <20080407212922.GA18657@ojjektum.uhulinux.hu>
References: <20080308110626.GE4491@ojjektum.uhulinux.hu> <200803211756.10987.rjw@sisk.pl> <20080403121035.GL29048@ojjektum.uhulinux.hu> <200804031711.56985.rjw@sisk.pl> <20080403200529.GA14399@kaos.in-kiel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403200529.GA14399@kaos.in-kiel.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 10:05:29PM +0200, Wilfried Klaebe wrote:
> Am Thu, Apr 03, 2008 at 05:11:55PM +0200 schrieb Rafael J. Wysocki:
> > On Thursday, 3 of April 2008, Pozsar Balazs wrote:
> > > On Fri, Mar 21, 2008 at 05:56:10PM +0100, Rafael J. Wysocki wrote:
> > > > On Friday, 21 of March 2008, Pozsar Balazs wrote:
> > > > > On Sun, Mar 09, 2008 at 10:01:55AM +0100, Pavel Machek wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > > I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> > > > > > > kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> > > > > > > suspend. The console is still on, the disk is powered off, but no 
> > > > > > > response or poweroff...
> > > > > > > 
> > > > > > > Did anyone else met the same thing? How could I help debug it?
> > > > > > > What other info would you need?
> > > > > > 
> > > > > > Find more exact version when it broke? git bisect?
> > > > > 
> > > > > I did not have time for bisect, but I have found that if I boot an 
> > > > > initrd and do not load the ata_piix module, suspend works, if I load it, 
> > > > > it hangs during suspend.
> > > > 
> > > > Hm, we have an ata_piix vs suspend problem on this box, then.
> > > > 
> > > > Any chance to verify if 2.6.24.x works?
> > > 
> > > I tried with ata_piix.c copied from 2.6.24, and it fails the same way.
> > 
> > It generally is not sufficient to replace just one file.  Please try the entire
> > 2.6.24.
> > 
> > Also, please check 2.6.25-rc8-git2, it might have fixed your issue.
> 
> I had the very same problems on a MacBook Pro 3.1 - 2.6.24 suspended and resumed,
> 2.6.25-rc[1-7] did not. I never had the time to bisect it, only to test newer RCs,
> and 2.6.25-rc8 just works.

2.6.25-rc8-git2 works for me too, problem solved!

Thanks.


-- 
pozsy
