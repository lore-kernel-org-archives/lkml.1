Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbYHSKCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbYHSKCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYHSKCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:02:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbYHSKCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:02:36 -0400
Date: Tue, 19 Aug 2008 03:02:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Vrabel <david.vrabel@csr.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net, jeffrey.t.kirsher@intel.com,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Message-Id: <20080819030221.728cc549.akpm@linux-foundation.org>
In-Reply-To: <48AA9757.3090002@csr.com>
References: <489C2457.5030104@csr.com>
	<20080818224011.6fad74dc.akpm@linux-foundation.org>
	<48AA9757.3090002@csr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 10:50:15 +0100 David Vrabel <david.vrabel@csr.com> wrote:

> Andrew Morton wrote:
> > On Fri, 08 Aug 2008 11:47:51 +0100 David Vrabel <david.vrabel@csr.com> wrote:
> > 
> >> 2.6.27-rc1 kernels appear to corrupt the EEPROM/NVM of the 8086:294c
> >> ethernet device (ICH9 I think).  After hacking the driver to ignore the
> >> bad CRC and MAC address I could view the EEPROM with ethtool and it was
> >> all 0xff.
> >>
> >> Testing EEPROM reads and writes with ethtool appeared to work but after
> >> a reboot of the system the ethernet device (see lspci -v output) was no
> >> longer present.  Could invalid EEPROM contents with a valid CRC (as
> >> would be the case after my read/write tests) result in the device
> >> failing to enumerate on the PCIe bus?
> 
> FYI, Jesse Brandeburg replied off-list and said that a corrupt EEPROM
> with a valid CRC can result in the device failing to enumerate.

I seem to recall one David S. Miller expressing strong opposition to
the e100[0] policy of escalating a dud EEPROM into a dead device.

> > Is this still happening in Linus's current tree?
> 
> I don't know, and I'm reluctant to try until I have a reliable way to
> restore an erased EEPROM.
> 
> > Was 2.6.26 OK?
> 
> 2.6.26 was fine.
> 

So we don't know why it corrupted the EEPROM?
