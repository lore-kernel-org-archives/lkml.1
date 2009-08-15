Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZHOVV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZHOVV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 17:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZHOVV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 17:21:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZHOVV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 17:21:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
Date: Sat, 15 Aug 2009 23:21:53 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0908151143560.18415-100000@netrider.rowland.org> <200908152254.23227.rjw@sisk.pl> <20090815205817.GA30254@srcf.ucam.org>
In-Reply-To: <20090815205817.GA30254@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908152321.53283.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 August 2009, Matthew Garrett wrote:
> On Sat, Aug 15, 2009 at 10:54:23PM +0200, Rafael J. Wysocki wrote:
> 
> > runtime_wakeup - if set, the device is allowed to do remote wakeup at run time
> >   That could be represented as 'runtime_wakeup' under 'power' with the
> >   following values:
> >   * no value (empty file) is 'runtime' is 'disabled'
> >   * 'enabled'
> >   * 'disabled'
> >   To set/unset the user space writes 'enabled'/'disabled' to it, respectively.
> >   The default is set.
> 
> Why would you ever want runtime_wakeup to be false unless 
> runtime_forbidden is true? Surely the point of runtime power management 
> is to be transparent to the user, in which case remote wakeup is 
> required?

Well, this was exactly my point previously. :-)

Still, although for the majority of devices 'runtime_wakeup' disabled would
mean no runtime PM at all IMO, there may be devices that actually work without
remote wakeup, although they support it in general.

I can even imagine a scenario where this setting might be useful, like when
we don't want a network adapter to be woken up from the outside.

Thanks,
Rafael
