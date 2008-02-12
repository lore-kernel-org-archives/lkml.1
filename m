Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYBLVug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYBLVug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYBLVu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:50:27 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44848 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751205AbYBLVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:50:26 -0500
Date: Tue, 12 Feb 2008 21:42:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Tim Ellis <tim@ngndg.com>, linux-kernel@vger.kernel.org, jeff@garzik.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
Message-ID: <20080212214258.1a05d6d2@core>
In-Reply-To: <1202850129.7410.22.camel@pasglop>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
	<1202850129.7410.22.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's strange though. Somebody with knowledge of that HW (or specs) who
> can spot something ? Could it be an issue with timing ?
> 
> I don't have HW access to this machine. If somebody could send one to me
> I could do more investigation.

Did anyone fix all the mmio posting bugs in libata-core that were pointed
out when I originally NAKked using MMIO, or did they just add the driver.

If the latter then you need to grep the various fix this notes in
libata-core around reset/probe of an SFF controller in particular.
