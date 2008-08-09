Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbYHIMhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbYHIMhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 08:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbYHIMhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 08:37:07 -0400
Received: from aun.it.uu.se ([130.238.12.36]:47967 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYHIMhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 08:37:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18589.36691.692149.811991@harpo.it.uu.se>
Date: Sat, 9 Aug 2008 14:36:35 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
In-Reply-To: <m3zlnm75u1.fsf@maximus.localdomain>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
	<20080808172629.232bed01@lxorguk.ukuu.org.uk>
	<njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
	<m3sktfw1v5.fsf@maximus.localdomain>
	<alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
	<20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
	<m3zlnm75u1.fsf@maximus.localdomain>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa writes:
 > @@ -147,7 +167,8 @@ config SATA_QSTOR
 >  
 >  config SATA_PROMISE
 >  	tristate "Promise SATA TX2/TX4 support"
 > -	depends on PCI
 > +	depends on PCI && ATA_SATA
 > +	select ATA_SFF
 >  	help
 >  	  This option enables support for Promise Serial ATA TX2/TX4.
 >  

NAK, sata_promise drives both sata and pata ports.
