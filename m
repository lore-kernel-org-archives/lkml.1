Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbXIVUM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbXIVUM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXIVUMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:12:22 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3593 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751013AbXIVUMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:12:21 -0400
Date: Sat, 22 Sep 2007 16:12:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] USB autosuspend and turning of usb pendrive
 leds
In-Reply-To: <46F54C08.3050300@hhs.nl>
Message-ID: <Pine.LNX.4.44L0.0709221610170.31951-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007, Hans de Goede wrote:

> >> Now call me naive, but I would expect a mass-storage devices with no 
> >> partitions mounted to autosuspend when autosuspend is enabled for that device.
> > 
> > Yes, that is naive.  The driver has no way to tell whether or not any 
> > partitions are mounted.  Furthermore, you might very well want to 
> > access the raw device without mounting any partitions (database 
> > managers frequently do such things to reduce I/O overhead), in which 
> > case you certainly would not the device to be autosuspended.
> > 
> 
> How does this relate to your "It works fine on my systems" remark, do I need to 
> do anything other the unmounting the paritions to make the device eligible for 
> autosuspend, like unbind the sd driver or even the usb-storage driver?

You shouldn't have to do anything.  Mounted or unmounted, bound to sd
or not bound, it shouldn't matter.  Provided the device isn't being
used, it ought to autosuspend.

I repeat: To find out what is really happening, you should use usbmon.

Alan Stern

