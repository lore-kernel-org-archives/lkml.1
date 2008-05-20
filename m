Return-Path: <linux-kernel-owner+w=401wt.eu-S933845AbYETQMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbYETQMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760534AbYETQLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:11:55 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:42031 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045AbYETQLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:11:53 -0400
Date: Tue, 20 May 2008 18:11:42 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       greg@kroah.com, linux-usb@vger.kernel.org
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred
	until reload of ehci-hcd
Message-ID: <20080520161142.GA4655@ics.muni.cz>
References: <20080520123423.GA4764@ics.muni.cz> <Pine.LNX.4.44L0.0805201117430.2114-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0805201117430.2114-100000@iolanthe.rowland.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 May 2008 18:11:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 11:20:10AM -0400, Alan Stern wrote:
> > On Tue, May 20, 2008 at 01:27:34PM +0200, Oliver Neukum wrote:
> > > > done.
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=10630
> > > 
> > > Aha. Thanks.
> > > Please recompile without CONFIG_USB_SUSPEND
> > 
> > Hm, without USB_SUSPEND it works. So what next, considered fixed or any
> > further investigation is needed?
> 
> No further investigation is needed.  I tried doing essentially the same 
> thing on my system and the same problem occurred.
> 
> It is caused by the way ehci-hcd "auto-clears" the port
> change-suspend feature.  This patch should fix the problem.  Please 
> try it out and let us know if it works.

seems to be working, device is detected. Thanks. Please, push the patch.

-- 
Luká¹ Hejtmánek
