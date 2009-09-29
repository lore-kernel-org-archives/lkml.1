Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbZI2Ufy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbZI2Ufy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZI2Ufx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:35:53 -0400
Received: from khc.piap.pl ([195.187.100.11]:51470 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZI2Ufx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:35:53 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Lennart Baruschka" <FunFlyer@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: Disabling DMA with ICH10?
References: <1254173481.4454.32.camel@goodbyte.homelinux.com>
	<20090928234025.6dc4e3f7@lxorguk.ukuu.org.uk>
	<20090929075416.77960@gmx.net> <20090929101114.1712314b@infradead.org>
	<m3bpku3peg.fsf@intrepid.localdomain>
	<20090929180555.3c4a7259@lxorguk.ukuu.org.uk>
Date: Tue, 29 Sep 2009 22:35:54 +0200
In-Reply-To: <20090929180555.3c4a7259@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Tue, 29 Sep 2009 18:05:55 +0100")
Message-ID: <m3k4zh32vp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Not that long, there is no emulation there (except for port #80 (hex?)
>> and similar). Normal 33 MHz access.
>
> ATA accesses go across the cable and while some of them are snooped,
> cached and other magic is done there are cases it turns into a
> transaction back and forth with the drive - that *is* slow. PIO 0 in fact
> is ISA speed

Sure, PATA inserts wait states, the 4 bus cycles per access (or
something like that) is the minimum for PIO on PCI. But it's still
normal 33 MHz access (with as many wait states as the PATA mode needs),
not ISA 8 MHz emulation (fastest PIO would be faster than ISA).
-- 
Krzysztof Halasa
