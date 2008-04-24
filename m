Return-Path: <linux-kernel-owner+w=401wt.eu-S1765353AbYDXPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765353AbYDXPcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765001AbYDXPau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:30:50 -0400
Received: from homer.mvista.com ([63.81.120.155]:1080 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764994AbYDXPas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:30:48 -0400
Message-ID: <4810A780.9040508@ru.mvista.com>
Date: Thu, 24 Apr 2008 19:30:08 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi>	<480DE3C4.5@ru.mvista.com>	<480DE6F5.8060403@gmail.com>	<480DE9E8.2070809@ru.mvista.com>	<480DEB1F.5060500@gmail.com>	<20080424123541.09e5ef96@the-village.bc.nu>	<481080EA.7010107@ru.mvista.com> <20080424152758.789e024c@the-village.bc.nu>
In-Reply-To: <20080424152758.789e024c@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>    If you mean SFF-8038i (which can indeed be named "SFF/Intel"), it
>>documents *only* BMDMA.  If you mean something else, please be more precise.

> It documents where the PIO spaces are mapped, the class codes and then

    I'd like to know what do you mean by "it" since it's certainly not in 
8038i spec I have.

> documents the rest by inheriting it from the other specs. That makes it
> the definitive spec for PCI "standard" controllers both PIO and DMA and

    That looks like ""Intel PCI IDE Controller Specification".

> it is indeed followed literally by just about every PCI ATA controller
> except the CS5520

    You probaly mean PC targeted controllers, since quite many non-PC chips do 
ignore that spec (IOC4, PowerMac, Toshiba SCC)... As for CS5520, what's the 
deviation here -- BMDMA regisrters at BAR2 only?

> Alan

MBR, Sergei
