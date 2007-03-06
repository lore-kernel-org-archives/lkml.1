Return-Path: <linux-kernel-owner+w=401wt.eu-S965888AbXCFOoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965888AbXCFOoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965889AbXCFOoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:44:14 -0500
Received: from twin.jikos.cz ([213.151.79.26]:34972 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965888AbXCFOoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:44:13 -0500
Date: Tue, 6 Mar 2007 15:44:07 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Amedee Van Gasse <amedee@amedee.be>
cc: LKML <linux-kernel@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
In-Reply-To: <1173191358.9292.4.camel@saruman>
Message-ID: <Pine.LNX.4.64.0703061536210.10909@twin.jikos.cz>
References: <1173122352.19761.33.camel@saruman>  <Pine.LNX.4.64.0703052249270.10909@twin.jikos.cz>
 <1173191358.9292.4.camel@saruman>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Amedee Van Gasse wrote:

> > This would be in fact very interesting to know. 1) does the BUG trigger 
> > only with newer versions of bluez-utils? 2) If so, does everything work 
> > with these older versions, or do the things fail in a same way, but 
> > silently?
> I could install an older version of my distribution and see what 
> happens, but that means I'll have to reserve some disk space and a lot 
> more time. I hope one of the many live cds also support bluetooth, that 
> would speed things up a lot. Will try to do that, but it'll take some 
> time.

I think that for the initial test just installing older version of 
bluez-utils might be enough to verify whether they do or don't cause the 
BUG to trigger.

> I installed something called usbsnoop and waved a lot of dead chickens 
> to convince the bluetooth receiver to pair again with the keyboard. 
> Attached is the logfile. I hope this helps, if not just tell me what you 
> need.

Thanks. Looks like there are the following reports that could potentially 
be used to switch the dongle from HID to HCI (assuming that Logitech 
didn't change behavior of its devices too much)

ff 80 00 00 03 00
ff 80 80 02 00 00
ff 80 80 01 00 00
(and maybe ff 80 09 01 00 00 ?)

This doesn't look like what is currently supported by hid2hci function 
switch_logitech(), but I would rather leave this to Marcel.

Thanks,

-- 
Jiri Kosina
