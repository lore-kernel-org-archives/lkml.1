Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYDCMKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYDCMKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYDCMKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:10:39 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:59437 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYDCMKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:10:38 -0400
Date: Thu, 3 Apr 2008 14:10:36 +0200
From: Pozsar Balazs <pozsy@uhulinux.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: suspend not working on macbook pro
Message-ID: <20080403121035.GL29048@ojjektum.uhulinux.hu>
References: <20080308110626.GE4491@ojjektum.uhulinux.hu> <20080309090155.GB3866@ucw.cz> <20080321085619.GA12152@ojjektum.uhulinux.hu> <200803211756.10987.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803211756.10987.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 05:56:10PM +0100, Rafael J. Wysocki wrote:
> On Friday, 21 of March 2008, Pozsar Balazs wrote:
> > On Sun, Mar 09, 2008 at 10:01:55AM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> > > > kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> > > > suspend. The console is still on, the disk is powered off, but no 
> > > > response or poweroff...
> > > > 
> > > > Did anyone else met the same thing? How could I help debug it?
> > > > What other info would you need?
> > > 
> > > Find more exact version when it broke? git bisect?
> > 
> > I did not have time for bisect, but I have found that if I boot an 
> > initrd and do not load the ata_piix module, suspend works, if I load it, 
> > it hangs during suspend.
> 
> Hm, we have an ata_piix vs suspend problem on this box, then.
> 
> Any chance to verify if 2.6.24.x works?

I tried with ata_piix.c copied from 2.6.24, and it fails the same way.

I'll try to bisect it if I have time.


-- 
pozsy
