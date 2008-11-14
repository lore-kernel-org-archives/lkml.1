Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYKNXrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYKNXrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYKNXrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:47:25 -0500
Received: from smtp2.ono.com ([62.42.230.20]:55043 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505AbYKNXrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:47:25 -0500
Date: Sat, 15 Nov 2008 00:47:22 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-IDE <linux-ide@vger.kernel.org>,
       Mdv Cooker <cooker@mandrivalinux.org>
Subject: sata-nv and 790i
Message-ID: <20081115004722.5158e125@werewolf.home>
X-Mailer: Claws Mail 3.6.1cvs25 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I recently put my hands on a system with an ASUS P5N64 WS Pro mobo:

http://www.asus.com/products.aspx?l1=3&l2=11&l3=653&l4=0&model=2182&modelmenu=1

It has a nForce 790i Ultra SLI chipset, the part for the SATA controller
is MCP55.

The problem is that linux seems to fail to read the hard drive on boot.
I will explain.

I have tried to install both CentOS 5.2 and Mandriva 2009.0.
For CentOS (has a 2.6.18 kernel), the install seems ok, but when I reboot
into the just intalled system the kernel hangs just after printing
the name of the initrd. Mandriva (2.6.27-rc8) just hungs half the install process.
Live versions of both hang on boot saying they can not find the root
device.

I have found some messages in the net about the MCP55 in that board not
being completeley suppported as AHCI in sata_nv, and that some other
boards work puttin the SATA controller in 'compatible' mode (with
loss of performance).
But I can't find any setting in the P5N64 to put SATA in Compat mode.

Can I do this via some kernel parameters ?
Somabody has this board working ? Do current kernels have better support
for this chipset ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.27.5-desktop-1mnb (gcc 4.3.2 (GCC) #1 Sun Nov
