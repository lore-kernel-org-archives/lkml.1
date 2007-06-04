Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbXFDJgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbXFDJgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbXFDJfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:35:47 -0400
Received: from eazy.amigager.de ([213.239.192.238]:34306 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbXFDJfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:35:46 -0400
Date: Mon, 4 Jun 2007 11:35:18 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: RTC_DRV_CMOS can break userspace interface
Message-ID: <20070604093518.GA29240@dose.home.local>
Mail-Followup-To: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <8pwhX-46n-3@gated-at.bofh.it> <8pCQo-5QL-7@gated-at.bofh.it> <87abvogbdp.fsf@buer.dfakt.de> <200705281406.57396.david-b@pacbell.net> <20070531043229.GA30888@dose.home.local> <20070531102603.GA16719@srcf.ucam.org> <20070601074606.GA6060@dose.home.local> <20070601125422.GA12204@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601125422.GA12204@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 13:54:23 +0100, Matthew Garrett wrote:
> On Fri, Jun 01, 2007 at 09:46:06AM +0200, Tino Keitel wrote:
> > Yes, you are right. I think this issue should be covered by Kconfig.
> > 
> > However:
> > 
> > $ cat wakealarm 
> > cat: wakealarm: Input/output error
> > 
> > It worked with /proc/acpi/alarm before.
> 
> Can you do 
> 
> for i in /sys/bus/pnp/devices/*; do if [ "$(cat $i/id)" = PNP0b00 ]; 
> then cat $i/resources; echo options; cat $i/options; fi; done

Here it is:

state = active
io 0x70-0x77
options

Regards,
Tino
