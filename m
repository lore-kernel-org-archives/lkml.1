Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbZAMN2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbZAMN2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760171AbZAMN2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:28:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48326 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbZAMN2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:28:06 -0500
Date: Tue, 13 Jan 2009 14:28:05 +0100
From: Pavel Machek <pavel@suse.cz>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Message-ID: <20090113132805.GE30352@atrey.karlin.mff.cuni.cz>
References: <20090113081316.GA2292@elf.ucw.cz> <200901131239.21995.rjw@sisk.pl> <200901131342.44562.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901131342.44562.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Am Dienstag 13 Januar 2009 schrieb Rafael J. Wysocki:
> > On Tuesday 13 January 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > Just when I thought long merge window means less problems...
> > > 
> > > ...suspend seemed to work until last tuesday or so. Now it hanged two
> > > times; once so hard that power button powercycle did not result in
> > > booting machine. (thinkpad x60)
> > > 
> > > I'll do some more tests...
> > 
> > There are a couple of things you may want to revert, like
> > 7503bfbae89eba07b46441a5d1594647f6b8ab7d and
> > a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 .
> > 
> > Please let me know if that helped.
> 
> I tested rc1+ these two reverts yesterday on my T61p. Doesnt work. There must 
> be at least one more patch that broke S2R on my thinkpad. In fact, it is cpu 
> hotplug that is broken (unplug works).

I reproduced that: echo 0 > online works, echo 1 > online hangs. Will
compile SMP-less kernel to verify that there are no more problems...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
