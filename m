Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbYI3TyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbYI3TyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYI3TyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:54:07 -0400
Received: from eazy.amigager.de ([213.239.192.238]:47390 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYI3TyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:54:06 -0400
Date: Tue, 30 Sep 2008 21:53:36 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Wakeup from suspend via keyboard and mouse doesn't work
	anymore with 2.6.27-rc
Message-ID: <20080930195336.GA12813@x61>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org
References: <20080922202911.GA9832@dose.home.local> <200809260035.09052.rjw@sisk.pl> <20080929211904.GB3185@dose.home.local> <200809292358.32634.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809292358.32634.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 23:58:32 +0200, Rafael J. Wysocki wrote:
> On Monday, 29 of September 2008, Tino Keitel wrote:
> > On Fri, Sep 26, 2008 at 00:35:08 +0200, Rafael J. Wysocki wrote:
> > 
> > [...]
> > 
> > > Can you please check if the appended patch restores the previous behavior?
> > 
> > Yes, with this patch wakeup using the keyboard works as it did with
> > 2.6.26.
> 
> Thanks for testing.
> 
> Can you also check if this patch is sufficient to fix the sky2 issue, or if you
> need the patch I sent in the sky2 thread in addition to it?

With this patch only, WOL is still broken. The machine doesn't wake up
and the power/wakeup entry for the sky2 device stays at "disabled"
after I enable WOL. With the WOL patch, power/wakeup changed to
"enabled" after "ethtool -s eth0 wol g".

Regards,
Tino
