Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYJNW0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYJNW0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYJNWZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:25:57 -0400
Received: from smtp3.ono.com ([62.42.230.176]:51573 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751844AbYJNWZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:25:56 -0400
Date: Wed, 15 Oct 2008 00:25:54 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: no SD card reader
Message-ID: <20081015002554.7b234a90@werewolf.home>
In-Reply-To: <20081014232759.08f5d212@werewolf.home>
References: <20081014025453.617f2ef8@werewolf.home>
	<20081014174536.1353d17e@mjolnir.drzeus.cx>
	<20081014232759.08f5d212@werewolf.home>
X-Mailer: Claws Mail 3.6.1cvs2 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 23:27:59 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Tue, 14 Oct 2008 17:45:36 +0200, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> 
> > On Tue, 14 Oct 2008 02:54:53 +0200
> > "J.A. Magallón" <jamagallon@ono.com> wrote:
> > 
> > > Hi...
> > > 
> > > More problems with git3. The left SD card reader is not detected on the One.
> > > With a working kernel (distro 2.6.27):
> > > 
> > > Oct 14 02:44:27 one kernel: mmc0: error -84 whilst initialising SD card
> > > 
> > > Any ideas ?
> > > 
> > 
> > -84 is -EILSEQ, which is some kind of bit error. Since you're running a
> > JMicron controller, I'm guessing that something in your system isn't
> > handling the higher speed (we forcefully enable highspeed on the
> > Jmicron controll now).
> > 
> 

> 01:00.0 System peripheral: JMicron Technologies, Inc. Device 2382
> 01:00.2 SD Host controller: JMicron Technologies, Inc. Device 2381
> 01:00.3 System peripheral: JMicron Technologies, Inc. Device 2383
> 01:00.4 System peripheral: JMicron Technologies, Inc. Device 2384
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
> 03:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
> 04:00.0 System peripheral: JMicron Technologies, Inc. Device 2382
> 04:00.2 SD Host controller: JMicron Technologies, Inc. Device 2381
> 04:00.3 System peripheral: JMicron Technologies, Inc. Device 2383
> 04:00.4 System peripheral: JMicron Technologies, Inc. Device 2384
> 

After updating pci.ids, lspci is more informative:

01:00.0 System peripheral: JMicron Technologies, Inc. SD/MMC Host Controller
01:00.2 SD Host controller: JMicron Technologies, Inc. Standard SD Host Controller
01:00.3 System peripheral: JMicron Technologies, Inc. MS Host Controller
01:00.4 System peripheral: JMicron Technologies, Inc. xD Host Controller
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
03:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
04:00.0 System peripheral: JMicron Technologies, Inc. SD/MMC Host Controller
04:00.2 SD Host controller: JMicron Technologies, Inc. Standard SD Host Controller
04:00.3 System peripheral: JMicron Technologies, Inc. MS Host Controller
04:00.4 System peripheral: JMicron Technologies, Inc. xD Host Controller

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
