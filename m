Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbXKHPET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbXKHPET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 10:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760851AbXKHPEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 10:04:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47124 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756693AbXKHPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 10:04:07 -0500
Date: Thu, 8 Nov 2007 10:04:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] BUG: usb Mouse continual disconnect (2.6.22.10)
 leading to eventual crash?
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0B89769@ecqcmtlmail3.quebec.int.ec.gc.ca>
Message-ID: <Pine.LNX.4.44L0.0711080959470.4149-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Fortier,Vincent [Montreal] wrote:

> > -----Message d'origine-----
> > De : Andrew Morton [mailto:akpm@linux-foundation.org] 
> > Envoyé : 7 novembre 2007 15:33
> > 
> > (+linux-usb-devel)
> > 
> > > On Wed, 7 Nov 2007 13:19:47 -0500 "Fortier,Vincent 
> > [Montreal]" <Vincent.Fortier1@EC.GC.CA> wrote:
> > > 
> > > I'm having a preblem with a few workstations that are hard freezing 
> > > from time to time since about a week.  Curiously since then we 
> > > upgraded from
> > > 2.6.20.6 to 2.6.20.10...
> > > 
> 
> [.....]
> 
> > > 
> > > Looking at the changes between 2.6.20.6 and 2.6.20.10 I only found 
> > > this USB related:
> > > 
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=commit;h=0e22438a5adfdf32b3bb1c75c81c01a29fba9770
> > > 
> > > I'm presuming that maybie eventually it might hit a input max barrier 
> > > (like a max of 1024) and then the kernel would be crashing?
> > > 
> > > Help very much appreciated!
> > 
> > People are going to want to know if this is still happening 
> > in 2.6.23 or 2.6.24-rc2, please.
> 
> I andrew,
> 
> (logged-in at wrok to make proper reply)
> 
> It might be tricky to test properly on 2.6.23.1 since theses are all
> operationnal aviation forecaster workstations 24/7 .... And sadly the
> problem only occur on a few of theses workstations AFAIK randomly ???  
> Actually many of them did not had any problems using the exact same
> FAI reinstallation using the same hardware..?!?!.
> 
> If someone thinks that the problem might effectively be the usb patch
> that I mentionned before (or any other patch that might make
> suddently thoses stations to freeze dur to a change that occur
> between 2.6.20.6 and .10) I would then be able to push a new kernel
> on thoses workstations without the offending patch(es) and have a
> clear answer within a week.

I have no idea what might be causing your problems, however that 
particular patch you found seems most unlikely to be connected.

One reasonably non-invasive way to do more testing is to use usbmon to 
record those multiple disconnect events.  Instructions are in the 
kernel source file Documentation/usb/usbmon.txt.

Alan Stern

