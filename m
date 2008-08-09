Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYHITMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYHITMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 15:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYHITMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 15:12:18 -0400
Received: from khc.piap.pl ([195.187.100.11]:58948 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYHITMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 15:12:18 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
	<20080808172629.232bed01@lxorguk.ukuu.org.uk>
	<njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
	<m3sktfw1v5.fsf@maximus.localdomain>
	<alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
	<20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
	<m3zlnm75u1.fsf@maximus.localdomain>
	<20080809141028.14db9bc7@lxorguk.ukuu.org.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 09 Aug 2008 21:12:02 +0200
In-Reply-To: <20080809141028.14db9bc7@lxorguk.ukuu.org.uk> (Alan Cox's message of "Sat\, 9 Aug 2008 14\:10\:28 +0100")
Message-ID: <m3skteuhod.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> CF can hang off any interface. Also in theory any PATA interface is also
> SATA as it may be combined with a bridge chip

But we don't drop PATA/SATA from the names and help texts, do we? :-)

Even if we do, we can still sort the single driver list
alphabetically, and we can still "select ATA_SFF" instead of the other
way around.
-- 
Krzysztof Halasa
