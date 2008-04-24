Return-Path: <linux-kernel-owner+w=401wt.eu-S1764169AbYDXPoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764169AbYDXPoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764013AbYDXPoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:44:01 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51396 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763993AbYDXPn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:43:59 -0400
Date: Thu, 24 Apr 2008 16:15:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6 patch] select ATA_SFF
Message-ID: <20080424161514.0e9c35b9@the-village.bc.nu>
In-Reply-To: <4810A780.9040508@ru.mvista.com>
References: <20080421213147.GH2633@cs181133002.pp.htv.fi>
	<480DE3C4.5@ru.mvista.com>
	<480DE6F5.8060403@gmail.com>
	<480DE9E8.2070809@ru.mvista.com>
	<480DEB1F.5060500@gmail.com>
	<20080424123541.09e5ef96@the-village.bc.nu>
	<481080EA.7010107@ru.mvista.com>
	<20080424152758.789e024c@the-village.bc.nu>
	<4810A780.9040508@ru.mvista.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     You probaly mean PC targeted controllers, since quite many non-PC chips do 
> ignore that spec (IOC4, PowerMac, Toshiba SCC)... As for CS5520, what's the 
> deviation here -- BMDMA regisrters at BAR2 only?

BMDMA at BAR 2, different class code, IDE side effectively not PCI (as
with the MPIIX)

Alan
