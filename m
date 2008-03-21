Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbYCUQ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbYCUQ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbYCUQ4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:56:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292AbYCUQ4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:56:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pozsar Balazs <pozsy@uhulinux.hu>
Subject: Re: suspend not working on macbook pro
Date: Fri, 21 Mar 2008 17:56:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
References: <20080308110626.GE4491@ojjektum.uhulinux.hu> <20080309090155.GB3866@ucw.cz> <20080321085619.GA12152@ojjektum.uhulinux.hu>
In-Reply-To: <20080321085619.GA12152@ojjektum.uhulinux.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803211756.10987.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 of March 2008, Pozsar Balazs wrote:
> On Sun, Mar 09, 2008 at 10:01:55AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> > > kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> > > suspend. The console is still on, the disk is powered off, but no 
> > > response or poweroff...
> > > 
> > > Did anyone else met the same thing? How could I help debug it?
> > > What other info would you need?
> > 
> > Find more exact version when it broke? git bisect?
> 
> I did not have time for bisect, but I have found that if I boot an 
> initrd and do not load the ata_piix module, suspend works, if I load it, 
> it hangs during suspend.

Hm, we have an ata_piix vs suspend problem on this box, then.

Any chance to verify if 2.6.24.x works?

Thanks,
Rafael

