Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYDCPMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYDCPMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbYDCPMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:12:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60719 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039AbYDCPMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:12:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pozsar Balazs <pozsy@uhulinux.hu>
Subject: Re: suspend not working on macbook pro
Date: Thu, 3 Apr 2008 17:11:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
References: <20080308110626.GE4491@ojjektum.uhulinux.hu> <200803211756.10987.rjw@sisk.pl> <20080403121035.GL29048@ojjektum.uhulinux.hu>
In-Reply-To: <20080403121035.GL29048@ojjektum.uhulinux.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031711.56985.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of April 2008, Pozsar Balazs wrote:
> On Fri, Mar 21, 2008 at 05:56:10PM +0100, Rafael J. Wysocki wrote:
> > On Friday, 21 of March 2008, Pozsar Balazs wrote:
> > > On Sun, Mar 09, 2008 at 10:01:55AM +0100, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> > > > > kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> > > > > suspend. The console is still on, the disk is powered off, but no 
> > > > > response or poweroff...
> > > > > 
> > > > > Did anyone else met the same thing? How could I help debug it?
> > > > > What other info would you need?
> > > > 
> > > > Find more exact version when it broke? git bisect?
> > > 
> > > I did not have time for bisect, but I have found that if I boot an 
> > > initrd and do not load the ata_piix module, suspend works, if I load it, 
> > > it hangs during suspend.
> > 
> > Hm, we have an ata_piix vs suspend problem on this box, then.
> > 
> > Any chance to verify if 2.6.24.x works?
> 
> I tried with ata_piix.c copied from 2.6.24, and it fails the same way.

It generally is not sufficient to replace just one file.  Please try the entire
2.6.24.

Also, please check 2.6.25-rc8-git2, it might have fixed your issue.

Thanks,
Rafael
