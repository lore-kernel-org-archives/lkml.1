Return-Path: <linux-kernel-owner+w=401wt.eu-S936992AbXHLWNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936992AbXHLWNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 18:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762067AbXHLWMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 18:12:51 -0400
Received: from ipx20189.ipxserver.de ([80.190.249.56]:3748 "EHLO
	ipx20189.ipxserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761607AbXHLWMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 18:12:50 -0400
X-Greylist: delayed 2105 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Aug 2007 18:12:50 EDT
Date: Sun, 12 Aug 2007 23:37:44 +0200
From: Christian Leber <christian@leber.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070812213743.GA21199@core>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz> <20070616194634.GA15953@core> <20070624204629.GA28049@core> <20070628140815.GA5339@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628140815.GA5339@ucw.cz>
X-Accept-Language: de en
X-Location: Europe, Germany, Mannheim
X-Operating-System: Debian GNU/Linux (sid)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 02:08:15PM +0000, Pavel Machek wrote:
> > > The results are a bit unclear, I took a 2.6.22-rc4 with beep.
> > > Logged into KDE.
> > > (hardware: Dell Latitude D810)
> > > 
> > > S = successfull resume
> > > D = had to resume 2 times, that means when pressing the power button the
> > > LED goes from blinking to on and after a few seconds it goes back to
> > > blinking, but without a beep in between; after pressing the power button
> > > a second time resume is successfull
> > > F = resume failes, NO beep
> > > 
> > > -run 1: D D F
> > > -run 2: D D D(some X garbadge) F
> > > -run 3: S S S S S S F
> > > -run 4: S S F
> > > -run 5: D F

[..]

> It may well be different problem :-(. 100KB diff and I'm not an acpi
> expert :-(.
> 
> I just discovered I have problems with s2ram, too, but it looks like
> usermodehelper is responsible.

Now i think it is a userspace problem, more exactly something in KDE.

I got a new laptop(a Dell D830) and
discovered that suspend works with gnome and when i directly run /etc/acpi/sleep.sh.
(with KDE running, from a xterm... but so somehow it can't interact with
the KDE userspace stuff) (i have no remote idea what KDE is doing)

So i tried sleep.sh also on my old laptop (D810) once again and it works
reliable, well at least for 13 times.

Directly afterwards i tried the suspend to ram button again and it
failed again as stated above.


Can someone else with suspend problems and KDE verify this?

i filled a bug against KDE in ubuntu:
https://bugs.launchpad.net/ubuntu/+source/kubuntu-meta/+bug/131855


Christian Leber

-- 
You are searching some interesting studies?
http://www.ziti.uni-heidelberg.de/   :-)

