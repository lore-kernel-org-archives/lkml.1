Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0BXNaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 08:30:52 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:31588
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757057Ab0BXNau convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 08:30:50 -0500
X-SpamScore: -28
X-BigFish: VPS-28(z21eWz1432R4015Lzz1202hzzz32i6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYCLJ2-04-3W2-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: SB600 64-bit DMA BIOS misconfiguration (formerly RE: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support)
Date: Wed, 24 Feb 2010 21:30:33 +0800
Message-ID: <C8E4BD7D001E44499280E0884BD9DB300183FB6B@sshaexmb1.amd.com>
In-Reply-To: <51f3faa71002232030u4679b6d0yc8df0679d8e19106@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: SB600 64-bit DMA BIOS misconfiguration (formerly RE: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support)
thread-index: Acq1CiWb2IrkeAD0SUe00uth9IurcQAR+psg
References: <4B7CAF95.6020306@gmail.com> <20100218042626.GB11649@kroah.com> <51f3faa71002172113o65a85ed6y5fa39d0b3a96f7ce@mail.gmail.com> <SNT125-W3300E8CCB5A9BD2D7B9942C3410@phx.gbl> <51f3faa71002232030u4679b6d0yc8df0679d8e19106@mail.gmail.com>
From: "Huang, Shane" <Shane.Huang@amd.com>
To: "Robert Hancock" <hancockrwd@gmail.com>,
       "Yuhong Bao" <yuhongbao_386@hotmail.com>
CC: <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>, <tj@kernel.org>,
       "Huang, Shane" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 13:30:39.0229 (UTC) FILETIME=[8DF9DAD0:01CAB555]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert and Yuhong,

> >> it doesn't work. Based on the libata experience with AHCI which has
a
> >> similar 64-bit feature flag, there are some controllers that didn't
do
> >> it properly, but not many (only ATI SB600 it appears, and only on
> >> certain boards, as it seems it was a BIOS configuration issue).
> > It seems it was solved by a DMI whitelist, but if it is a BIOS
configuration issue, I think it would be better if it could be detected
directly
> instead by reading the configuration directly from the device and
correcting it if possible. Is that possible?
> 
> That would likely be the ideal solution, but only AMD would likely
> have the info needed to do that, if it's possible..

Yes, I did see SB600 64 bit DMA issue on several SB600 platforms,
especially the SATA controller and HD audio controller.
But we do not know the root cause, which seems to be BIOS related
after debug. So far what I know is:

1. The 64bit DMA issue only appears on few SB600 platforms, while
We do NOT see it on SB700, SB800 and our own SB600 reference boards.

2. According to the debug to ASUS M2A-VM SATA controller, some
BIOS change between version 1404 and 1501 lead to the issue:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
t;h=58a09b38cfcd700b796ea07ae3d2e0efbb28b561

3. I do not get any related SB600 errata or known issue confirmation
from our HW team, we do not think it is HW issue.

So I do not have too much suggestion but one:
If you have any contact window to ASUS, is it possible for you to
ask ASUS to check the difference between 1404 and 1501?
We might get clue from the change list.


Thanks,
Shane


