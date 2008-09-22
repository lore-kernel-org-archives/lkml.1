Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYIVVRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYIVVRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYIVVRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:17:43 -0400
Received: from eazy.amigager.de ([213.239.192.238]:52248 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIVVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:17:42 -0400
Date: Mon, 22 Sep 2008 23:18:44 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Wakeup from suspend via keyboard and mouse doesn't work
	anymore with 2.6.27-rc
Message-ID: <20080922211844.GA7049@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080922202911.GA9832@dose.home.local> <200809222309.34413.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809222309.34413.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 23:09:34 +0200, Rafael J. Wysocki wrote:
> On Monday, 22 of September 2008, Tino Keitel wrote:
> > Hi,
> 
> Hi,
> 
> > my Mac mini core duo used to wake up from suspend to RAM when a key or
> > mouse button is pressed. This doesn't work anymore with 2.6.27-rc, the
> > current version that I tried is 2.6.27-rc7. I checked /proc/acpi/wakeup
> > for differences, with 2.6.26 and 2.6.27-rc, but both were identical:
> 
> Did you test that with any 2.6.27-rc before -rc7?

Only -rc6 IIRC.

> > Any hints if there are some commits that I should try to revert, before
> > I start bisecting?
> 
> I don't think you need to revert anything. :-)
> 
> Please check if the /sys/devices/.../power/wakeup file contains 'enabled' for
> the USB controller pci:0000:00:1d.7 (I assume this is the one the keyboard &
> mouse are attached to).  If it doesn't, please try to write 'enabled' to this
> file and retest.

Yes, this works. Thanks.

Regards,
Tino
