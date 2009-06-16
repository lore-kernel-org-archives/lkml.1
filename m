Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbZFPO0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbZFPO0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbZFPO0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:26:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53121 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756236AbZFPO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:26:20 -0400
Date: Tue, 16 Jun 2009 10:26:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Meyer <thomas@m3y3r.de>
cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
In-Reply-To: <1245083361.6821.1.camel@localhost>
Message-ID: <Pine.LNX.4.44L0.0906161024270.3740-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Thomas Meyer wrote:

> Am Sonntag, den 14.06.2009, 22:50 +0200 schrieb Jiri Kosina:
> > On Sun, 14 Jun 2009, Rafael J. Wysocki wrote:
> > 
> > > As for the mouse itself, I don't know.  I'm not even sure if it's 
> > > possible at all (CCing Jiri).
> > 
> > The main question is whether the mouse really is generating wakeup event 
> > even if unused.
> > 
> > Could you please provide usbmon dumps (Documentation/usb/usbmon.txt) from 
> > the failing suspend session?
> 
> I tried and usbmon seems to kill my machine. See attached screenshot.

Pete Zaitcev recently posted some patches intended to prevent usbmon 
from crashing:

	http://marc.info/?l=linux-usb&m=124473160415043&w=2
	http://marc.info/?l=linux-usb&m=124473231116168&w=2

Maybe they will allow you to use usbmon.

Alan Stern

