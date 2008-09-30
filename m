Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYI3UFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYI3UFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYI3UFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:05:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYI3UFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:05:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Wakeup from suspend via keyboard and mouse doesn't work anymore with 2.6.27-rc
Date: Tue, 30 Sep 2008 22:09:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080922202911.GA9832@dose.home.local> <200809292358.32634.rjw@sisk.pl> <20080930195336.GA12813@x61>
In-Reply-To: <20080930195336.GA12813@x61>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809302209.14209.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 30 of September 2008, Tino Keitel wrote:
> On Mon, Sep 29, 2008 at 23:58:32 +0200, Rafael J. Wysocki wrote:
> > On Monday, 29 of September 2008, Tino Keitel wrote:
> > > On Fri, Sep 26, 2008 at 00:35:08 +0200, Rafael J. Wysocki wrote:
> > > 
> > > [...]
> > > 
> > > > Can you please check if the appended patch restores the previous behavior?
> > > 
> > > Yes, with this patch wakeup using the keyboard works as it did with
> > > 2.6.26.
> > 
> > Thanks for testing.
> > 
> > Can you also check if this patch is sufficient to fix the sky2 issue, or if you
> > need the patch I sent in the sky2 thread in addition to it?
> 
> With this patch only, WOL is still broken. The machine doesn't wake up
> and the power/wakeup entry for the sky2 device stays at "disabled"
> after I enable WOL. With the WOL patch, power/wakeup changed to
> "enabled" after "ethtool -s eth0 wol g".

OK, thanks for testing.

I'm going to submit the sky2 patch for merging too.

Thanks,
Rafael
