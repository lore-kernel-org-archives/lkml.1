Return-Path: <linux-kernel-owner+w=401wt.eu-S1764247AbZFNUpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764247AbZFNUpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763315AbZFNUow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:44:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51323 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764081AbZFNUov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:44:51 -0400
Date: Sun, 14 Jun 2009 16:44:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Thomas Meyer <thomas@m3y3r.de>, Frans Pop <elendil@planet.nl>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
In-Reply-To: <200906142129.08135.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906141639430.21467-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Rafael J. Wysocki wrote:

> > Good idea. I should have thought of this myself. No, it's not above
> > device. I just tested several constellations and it's seems to be my usb
> > mouse. when the mouse is unplug suspend to ram works reliably.
> > 
> > how to fix the mouse's behaviour?
> 
> In principle, you should be able to disable wake-up on the USB controllers.

It should already be disabled.  Worth checking, though.  
/sys/devices/pci0000:00/0000:00:02.1/power/wakeup is the file to look 
at.

> As for the mouse itself, I don't know.  I'm not even sure if it's possible at
> all (CCing Jiri).

In theory you can disable remote wakeup on the mouse through the usual
mechanism.  The real question is why the mouse seems to be generating a
wakeup request when there's no apparent reason to do so.

Maybe it's just faulty.

Alan Stern

