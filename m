Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbZGTHsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbZGTHsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZGTHsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:48:04 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:33801 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbZGTHsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:48:03 -0400
Message-ID: <4A642130.8030303@msgid.tls.msk.ru>
Date: Mon, 20 Jul 2009 11:48:00 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: w@1wt.eu
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.37.3
References: <20090719234914.GA3765@hera.kernel.org>
In-Reply-To: <20090719234914.GA3765@hera.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Linux 2.4.37.3 has just been released.
[]
> The second major issue concerns the r8169 driver. Approximately one
> month ago was revealed an issue with this driver, causing kernel
> panics and possibly more if too large frames were sent to the chip
> (CVE-2009-1389). 2.4 was not affected by the bug, but showed the
> same symptoms. It turned out that there were multiple issues with
> the setting of RX descriptors after reuse, and some recent 2.6
> fixes allowing automatic recovery were missing. So after two long
> days trying to figure out why that damn chip insisted in writing
> more bytes than allowed (and crashing my box), I could spot and
> fix the issues.
> 
> If there are 2.4 users with this cheap NIC, I strongly suggest that
> they upgrade, especially if they're used to encounter freezes or
> lack of network connectivity once in a while ; for others, well, do
> not buy that NIC.

The thing is that this very nic is used on-board on vast majority of
mainboards, at least in cheap- to mid-range price, for amd and intel
processors.  Also many notebooks use this chip series.  Several months
ago I were shopping for a mainboard with certain characteristics (I
needed 3 PCI ports and a way to plug some monitor, and support for 4
ECC DIMMs and recent Phenom processors) - it was difficult to find such
a combination alone, without additional constrains for !r8169 chip
(I finally bought Asus M3A-H/HDMI mobo with atl1 NIC, just by a chance).

/mjt
