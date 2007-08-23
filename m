Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXHWPSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXHWPSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763170AbXHWPR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:17:57 -0400
Received: from main.gmane.org ([80.91.229.2]:45311 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762155AbXHWPR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:17:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: TV card detected wrongly by the kernel. Any chance to get this
   fixed?
Date: Thu, 23 Aug 2007 17:23:03 +0200
Message-ID: <fak8ei$jg1$1@sea.gmane.org>
References: <fai89b$ms1$1@sea.gmane.org>  <20070822215148.GL30705@stusta.de> <1187823357.7104.25.camel@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4c35e.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070809 SeaMonkey/1.1.4
In-Reply-To: <1187823357.7104.25.camel@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> If your board have an unique PCI ID, we may add it to the driver,
> avoiding this need. For this, we will need the results of the following
> command:
> 
> lspci -vv -nn

I'm using card=65 to use my card. I never tried the tuner (don't need 
it) but the composite-in works for displaying the input of my sattelite 
receiver and I'm able to read videotext, too. Without "card=65", I only 
got black/white output...

Here are the values of the lspci -vv -nn command. I reduced the output 
to the two entries, belonging to the card.

00:10.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at e7004000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at e7005000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Thanks in advance for your answer.

CU

Manuel

