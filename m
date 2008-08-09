Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYHIN1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYHIN1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 09:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYHIN1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 09:27:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42968 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751547AbYHIN1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 09:27:46 -0400
Date: Sat, 9 Aug 2008 14:10:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
Message-ID: <20080809141028.14db9bc7@lxorguk.ukuu.org.uk>
In-Reply-To: <m3zlnm75u1.fsf@maximus.localdomain>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
	<20080808172629.232bed01@lxorguk.ukuu.org.uk>
	<njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
	<m3sktfw1v5.fsf@maximus.localdomain>
	<alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
	<20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
	<m3zlnm75u1.fsf@maximus.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure about IXP4XX_CF (compact flash) case, it's essentially
> PATA but the physical interface is a bit different and it may be
> confusing(?). Also not sure about Pacific Digital ADMA, is it
> PATA-only or both?

CF can hang off any interface. Also in theory any PATA interface is also
SATA as it may be combined with a bridge chip
