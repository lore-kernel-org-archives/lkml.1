Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZGKLIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZGKLIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZGKLId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:08:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZGKLIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:08:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Mahalingam, Nithish" <nithish.mahalingam@intel.com>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 8)
Date: Sat, 11 Jul 2009 13:08:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <aec7e5c30907081952t4b88f1ccjeec6ab11b1d913b8@mail.gmail.com> <aec7e5c30907090831y180b0972o6dcb961dd292a3c0@mail.gmail.com> <175E0F9A9EFCEA46A65F5552BB057298BB5F3EA2@bgsmsx502.gar.corp.intel.com>
In-Reply-To: <175E0F9A9EFCEA46A65F5552BB057298BB5F3EA2@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907111308.44388.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 July 2009, Mahalingam, Nithish wrote:
> Hi,

Hi,

> I am newbee to this mailing list. Please excuse me if I am talking nonsense here.
> 
> 
> 
> On Thu, Jul 9, 2009 at 10:48 PM, Alan Stern<stern@rowland.harvard.edu> wrote:
> >> On Thu, 9 Jul 2009, Magnus Damm wrote:
> >>
> >>> Clocks should be stopped as soon as possible without any delay. The
> >>> clock stopping is very cheap performance wise. Also, the clock
> >> stopping is done on bus level without invoking any driver callbacks.
> >>> Delaying the clock stopping does not make any sense to me.
> >>
> >> In that case the device driver or bus subsystem should manage the
> >> device's clock directly.  There's no need to tie it in with the runtime
> >> PM framework.  Simply start the clock before each I/O operation and
> >> stop it afterward.
> 
> > It's not that easy. The clock needs to be enabled to let the hardware
> > device perform device specific stuff. For instance, the clock for the
> > LCD controller needs to be on to redraw the screen. When the driver
> > knows that it's done with the clock it can notify the bus using
> > Runtime PM.
> 
> Is there any plan to look into the "Clock Framework" that was developed as
> part of OMAP and extending this to make it generic for all platforms?

I don't have any plan to do that and I heaven't heard of anyone planning to do
it.

Best,
Rafael
