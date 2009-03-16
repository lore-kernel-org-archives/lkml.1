Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbZCPVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbZCPVyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbZCPVyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:54:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50891 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbZCPVyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:54:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: No warning on resume with different kernel version
Date: Mon, 16 Mar 2009 22:53:55 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200903141629.05282.eike-kernel@sf-tec.de> <200903162133.10526.rjw@sisk.pl> <20090316212329.GA12308@elf.ucw.cz>
In-Reply-To: <20090316212329.GA12308@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903162253.55940.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009, Pavel Machek wrote:
> On Mon 2009-03-16 21:33:10, Rafael J. Wysocki wrote:
> > On Monday 16 March 2009, Pavel Machek wrote:
> > > On Sat 2009-03-14 16:28:59, Rolf Eike Beer wrote:
> > > > Hi,
> > > > 
> > > > I'm sure this had worked before. And since I don't do that on a regular basis, 
> > > > but only by accident, I have no idea when it stopped working. But with my 
> > > > 2.6.28 kernel and everything more recent I don't get a warning if there is a 
> > > > suspend image of a different kernel version, but simply the new kernel starts 
> > > > and throws everything away. Is this a kernel fault or something with the 
> > > > userspace stuff? Whom to blame for this?
> > > 
> > > Actually, it should now be possible to resume with different kernel
> > > than the one that did the suspendding...
> > 
> > As long as it is 64-bit.
> > 
> > Something broke if that doesn't work.
> > 
> > Rolf, is your kernel 64-bit?
> 
> And in 32-bit case, we should refuse to load the image. Something
> broke if that does not work :-).

Well, the description suggests the boot kernel didn't load the image, but
just continued to boot.  That really depends on what "throws everything away"
means in the original report.  Rolf?

Rafael
