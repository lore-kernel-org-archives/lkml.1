Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYHRPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYHRPOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYHRPOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:14:04 -0400
Received: from xenotime.net ([66.160.160.81]:54470 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751028AbYHRPOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:14:02 -0400
Date: Mon, 18 Aug 2008 08:14:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Aivils Stoss <aivils@latnet.lv>
Cc: lud <linux-usb@vger.kernel.org>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-input@vger.kernel.org, jkosina@suse.cz,
       linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
Message-Id: <20080818081432.782d9632.rdunlap@xenotime.net>
In-Reply-To: <200808181642.49489.aivils@latnet.lv>
References: <200808080702.24969.aivils@latnet.lv>
	<200808100408.37473.aivils@latnet.lv>
	<20080814184948.093d2cad.rdunlap@xenotime.net>
	<200808181642.49489.aivils@latnet.lv>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 16:42:49 +0530 Aivils Stoss wrote:

> On Friday 15 August 2008 7:19:48 am Randy Dunlap wrote:
> > On Sun, 10 Aug 2008 04:08:37 +0100 Aivils Stoss wrote:
> > > On Saturday 09 August 2008 11:42:26 am Samuel Thibault wrote:
> > > > Aivils Stoss, le Fri 08 Aug 2008 07:02:24 +0100, a écrit :
> > > > > I suppose this is Linux kernel bug because i test keyboards under
> > > > > Windows, which support any schema of cascading of usb hubs.
> > > >
> > > > On the very same machine and hubs?
> > >
> > > Yes, on same machine. Under Windows i don't have evdev interface,
> > > checked only how keypress go to console.
> > > Of course to repeat a try You must have at least 5 keyboards and
> > > 1 7-port or 2 4-port hubs and kernel 2.6.22 and above. I allways
> > > got result - 5th, 6th, 7th keyboard does not send events to console
> > > or evdev.
> >
> > [adding linux-usb mailing list]
> >
> > Hi,
> >
> > I finally got 5 USB keyboards together along with 2 hubs.
> > I daisy-chained the hubs and connected 1 keyboard to the hub that is
> > on the notebook computer USB port, then I connected 4 keyboards to the
> > second hub.  They all worked for me, meaning that I can type on all of
> > them and have their characters show up on my console.
> >
> > I'm testing with 2.6.7-rc2.
> > 'usbtree' output of the USB subsystem is attached.
> 
> Yeah! 2.6.7 is a bit obsolete. At my end 2.6.15 support more than 4
> keyboards per PC port , but mess up input when is plugged more than
> 9 keyboards. 10th is capable to send keypress events, but last pressed
> key will be repeated until ctrl-c . 10th keyboard disturb an auto repeat of 
> all keyboards.

Sorry, my keyboard made a typo.  I'm testing with 2.6.27-rc2.

So the problem is now different from your original report, right?


What speed is the host port that the keyboards are connected to?
Could it be a USB bus bandwidth limitation?  (not that any code
checks for that)

I barely found 5 USB keyboards, so I surely can't test 10 or more.  ;)
I suppose that it will take some USB debug messages to attempt to see
what is going on...


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
