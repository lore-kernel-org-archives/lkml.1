Return-Path: <linux-kernel-owner+w=401wt.eu-S1161210AbXAMLC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161210AbXAMLC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jan 2007 06:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161223AbXAMLC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jan 2007 06:02:59 -0500
Received: from eazy.amigager.de ([213.239.192.238]:48191 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161210AbXAMLC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jan 2007 06:02:58 -0500
Date: Mon, 17 Jan 2000 05:43:55 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: Pavel Machek <pavel@ucw.cz>, Luming Yu <luming.yu@gmail.com>,
       Adrian Bunk <bunk@stusta.de>, Lee Revell <rlrevell@joe-job.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc3 regression: suspend to RAM broken on Mac mini Core Duo
Message-ID: <20000117044355.GA13093@dose.home.local>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Luming Yu <luming.yu@gmail.com>, Adrian Bunk <bunk@stusta.de>,
	Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
References: <1168194194.18788.63.camel@mindpipe> <20070107200453.GA3227@thinkpad.home.local> <20070107222706.GA6092@thinkpad.home.local> <20070107234445.GM20714@stusta.de> <20070108210428.GA7199@dose.home.local> <3877989d0701090651m84d7f41v5d06e1638a7eb31d@mail.gmail.com> <20070109231655.GA5958@thinkpad.home.local> <20070112145025.GB7685@ucw.cz> <20070113030528.GA8269@dose.home.local> <20070113034512.GA6422@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070113034512.GA6422@dose.home.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 13, 2007 at 04:45:12 +0100, Tino Keitel wrote:
> On Sat, Jan 13, 2007 at 04:05:28 +0100, Tino Keitel wrote:
> 
> [...]
> 
> > I think I found the problem. In 2.6.18, I had a slightly different
> > config. With 2.6.20-rc4, I had sucessful suspend/resume cycles without
> > the USB DVB-T box attached. I tweaked the USB options a bit and
> > activated some options (CONFIG_USB_SUSPEND,
> > CONFIG_USB_MULTITHREAD_PROBE, CONFIG_USB_EHCI_SPLIT_ISO,
> > CONFIG_USB_EHCI_ROOT_HUB_TT, CONFIG_USB_EHCI_TT_NEWSCHED) and now I can
> > suspend/resume without hangs. At least I haven't seen one until now.
> 
> Just after I sent the mail, I had 2 failures again. :-(

PM_TRACE revealed that the Ethernet driver (sky2) failed to resume. I
removed the patches for wake on LAN and hope that it works now.

Regards,
Tino
