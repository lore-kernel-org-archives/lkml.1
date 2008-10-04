Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYJDU1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYJDU1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYJDU0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:26:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYJDU0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:26:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [Bug #11442] btusb hibernation/suspend breakage in current -git
Date: Sat, 4 Oct 2008 22:31:05 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.ab.L675IB@wind> <1223151431.11272.54.camel@violet.holtmann.net>
In-Reply-To: <1223151431.11272.54.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810042231.05823.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 4 of October 2008, Marcel Holtmann wrote:
> Hi Rafael,
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11442
> > Subject		: btusb hibernation/suspend breakage in current -git
> > Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> > Date		: 2008-08-25 11:37 (41 days old)
> > References	: http://marc.info/?l=linux-bluetooth&m=121966402012074&w=4
> > Handled-By	: Oliver Neukum <oliver@neukum.org>
> > Patch		: http://marc.info/?l=linux-bluetooth&m=121967226027323&w=4
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=11442#c1
> 
> the patch is not the actual fix for it. It is just a band aid. As you
> confirmed, the double free patch fixes it. See my pull request, but it
> didn't make it into Linus' tree yet.

I know, I didn't close this entry just because the fix is not yet in the Linus'
tree.

Thanks,
Rafael


> Please pull from
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git master
> 
> This will update the following files:
> 
>  drivers/bluetooth/bpa10x.c |    2 --
>  drivers/bluetooth/btusb.c  |    7 ++++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> through these ChangeSets:
> 
> Marcel Holtmann (2):
>     [Bluetooth] Fix double frees on error paths of btusb and bpa10x drivers
>     [Bluetooth] Add reset quirk for new Targus and Belkin dongles
