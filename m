Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZI2M31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZI2M31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZI2M30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:29:26 -0400
Received: from khc.piap.pl ([195.187.100.11]:55811 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZI2M30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:29:26 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Lennart Baruschka" <FunFlyer@gmx.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Disabling DMA with ICH10?
References: <1254173481.4454.32.camel@goodbyte.homelinux.com>
	<20090928234025.6dc4e3f7@lxorguk.ukuu.org.uk>
	<20090929075416.77960@gmx.net> <20090929101114.1712314b@infradead.org>
Date: Tue, 29 Sep 2009 14:29:27 +0200
In-Reply-To: <20090929101114.1712314b@infradead.org> (Arjan van de Ven's
	message of "Tue, 29 Sep 2009 10:11:14 +0200")
Message-ID: <m3bpku3peg.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> a single PIO instruction will NOT be interrupted by an interrupt.
> And can easily take several microseconds (remember: 8Mhz bus
> emulation)

Not that long, there is no emulation there (except for port #80 (hex?)
and similar). Normal 33 MHz access. But it's still slow, of course -
every access takes at least 4(?) bus cycles (IIRC: address, initiator
ready, device selected, target ready). No bursts (at least on typical
x86 hw).

Of course ICH10 AHCI isn't connected with PCI 33/32 bus.

Anyway: PIO = bad idea.
-- 
Krzysztof Halasa
