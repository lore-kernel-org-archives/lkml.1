Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbYKXAfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbYKXAfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 19:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYKXAfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 19:35:45 -0500
Received: from smtp.ono.com ([62.42.230.12]:31331 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750990AbYKXAfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 19:35:45 -0500
Date: Mon, 24 Nov 2008 01:35:42 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: nForce 790i/MCP55: sata-nv or ahci ?
Message-ID: <20081124013542.16778a41@werewolf.home>
X-Mailer: Claws Mail 3.6.1cvs37 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have read that modern nVidia SATA's are AHCI. But several distros I have
tried use the sata-nv module for that chipset controller (MCP55).
Is this correct or should I use standard ahci ? Anyways, it looks that the
kernel/modprobe settings use this, can I change it via kernel cmdline
or modprobe.conf, and force the system to try ahci module ?
By BIOS has no kind of setting to put the controlled in AHCI vs SATA mode...
Playing with alias pci:v000010DEd0000037Fsv*sd*bc*sc*i* ?

wargo:~> lspci -s 00:0e
00:0e.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
00:0e.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
00:0e.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
wargo:~> lspci -ns 00:0e
00:0e.0 0101: 10de:037f (rev a3)
00:0e.1 0101: 10de:037f (rev a3)
00:0e.2 0101: 10de:037f (rev a3)

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.27.5-desktop-1mnb (gcc 4.3.2 (GCC) #1 Sun Nov
