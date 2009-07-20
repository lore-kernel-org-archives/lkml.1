Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZGTJbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZGTJbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 05:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZGTJbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 05:31:38 -0400
Received: from 1wt.eu ([62.212.114.60]:33592 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZGTJbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 05:31:37 -0400
Date: Mon, 20 Jul 2009 11:31:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.37.3
Message-ID: <20090720093134.GE11392@1wt.eu>
References: <20090719234914.GA3765@hera.kernel.org> <4A642130.8030303@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A642130.8030303@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 11:48:00AM +0400, Michael Tokarev wrote:
> Willy Tarreau wrote:
> >Linux 2.4.37.3 has just been released.
> []
> >The second major issue concerns the r8169 driver. Approximately one
> >month ago was revealed an issue with this driver, causing kernel
> >panics and possibly more if too large frames were sent to the chip
> >(CVE-2009-1389). 2.4 was not affected by the bug, but showed the
> >same symptoms. It turned out that there were multiple issues with
> >the setting of RX descriptors after reuse, and some recent 2.6
> >fixes allowing automatic recovery were missing. So after two long
> >days trying to figure out why that damn chip insisted in writing
> >more bytes than allowed (and crashing my box), I could spot and
> >fix the issues.
> >
> >If there are 2.4 users with this cheap NIC, I strongly suggest that
> >they upgrade, especially if they're used to encounter freezes or
> >lack of network connectivity once in a while ; for others, well, do
> >not buy that NIC.
> 
> The thing is that this very nic is used on-board on vast majority of
> mainboards, at least in cheap- to mid-range price, for amd and intel
> processors.  Also many notebooks use this chip series.  Several months
> ago I were shopping for a mainboard with certain characteristics (I
> needed 3 PCI ports and a way to plug some monitor, and support for 4
> ECC DIMMs and recent Phenom processors) - it was difficult to find such
> a combination alone, without additional constrains for !r8169 chip
> (I finally bought Asus M3A-H/HDMI mobo with atl1 NIC, just by a chance).

Yes I know that too. It took me some time to try to find a mainboard
without this chip. Gigabyte puts it everywhere, which is the *only*
reason I avoid their mainboards, which I find nice and reliable otherwise.
It's not acceptable to have such a crap on a $200 mainboard, that's not
the proper way to kill costs, as it costs one PCIe slot for the end user
to have decent network connectivity.

Fortunately we don't find it in servers, but it's often seen on low-end
embedded mainboards which have upgraded from 10/100 (8139) to 1000 (8169).

Willy

