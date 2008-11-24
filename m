Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbYKXFfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbYKXFfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 00:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYKXFff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 00:35:35 -0500
Received: from main.gmane.org ([80.91.229.2]:46894 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYKXFfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 00:35:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: nForce 790i/MCP55: sata-nv or ahci ?
Date: Sun, 23 Nov 2008 23:35:22 -0600
Message-ID: <492A3D1A.10907@shaw.ca>
References: <20081124013542.16778a41@werewolf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <20081124013542.16778a41@werewolf.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> Hi all...
> 
> I have read that modern nVidia SATA's are AHCI. But several distros I have
> tried use the sata-nv module for that chipset controller (MCP55).

Only ones more modern than that (MCP65 and later) are AHCI, MCP55 still 
uses sata_nv.

> Is this correct or should I use standard ahci ? Anyways, it looks that the
> kernel/modprobe settings use this, can I change it via kernel cmdline
> or modprobe.conf, and force the system to try ahci module ?
> By BIOS has no kind of setting to put the controlled in AHCI vs SATA mode...
> Playing with alias pci:v000010DEd0000037Fsv*sd*bc*sc*i* ?
> 
> wargo:~> lspci -s 00:0e
> 00:0e.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
> 00:0e.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
> 00:0e.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
> wargo:~> lspci -ns 00:0e
> 00:0e.0 0101: 10de:037f (rev a3)
> 00:0e.1 0101: 10de:037f (rev a3)
> 00:0e.2 0101: 10de:037f (rev a3)
> 
> TIA
> 

