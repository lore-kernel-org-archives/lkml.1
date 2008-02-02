Return-Path: <linux-kernel-owner+w=401wt.eu-S933711AbYBBSHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbYBBSHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYBBSHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:07:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2025 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023AbYBBSHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:07:18 -0500
Date: Sat, 2 Feb 2008 14:15:55 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce softpanic
Message-ID: <20080202141554.GB4456@ucw.cz>
References: <alpine.LSU.0.999.0801251551060.21522@be1.lrz> <p73ejc67xvb.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ejc67xvb.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-01-25 16:01:28, Andi Kleen wrote:
> Bodo Eggert <7eggert@gmx.de> writes:
> 
> > Enabling this option changes a hard panic on boot errors to a
> > soft panic, which does not stop the system completely.
> > You can still scroll the screen and read the messages.
> 
> I don't think it's a good idea to keep the network running in the
> soft panic. A lot of people have set ups that use ping was a watchdog
> and with nfsroot/ip=dhcp ping does work quite well before
> mounting root and then the watchdog might not pick up the 
> soft panic.
> 
> Using a polled keyboard driver after panic seems to be the better
> option to me, but if you want softpanic you should probably
> at least add a suitable panic notifier to the network stack 
> to shut it all down.

OTOH this will allow netconsole/sysrq over it to still work after
softpanic, which is good. Lets not over engineer it, I think current
code is fine.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
