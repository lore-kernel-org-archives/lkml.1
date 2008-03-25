Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYCYXyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYCYXyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbYCYXyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:54:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755869AbYCYXyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:54:23 -0400
Date: Tue, 25 Mar 2008 23:36:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>, Tim Ellis <tim@ngndg.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Work around breakage introduced in pata_sil680 by
 switching it to MMIO
Message-ID: <20080325233629.1fcc2eaa@core>
In-Reply-To: <Pine.LNX.4.64.0803260023030.1539@axis700.grange>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
	<1202850129.7410.22.camel@pasglop>
	<Pine.LNX.4.64.0802151651340.27735@axis700.grange>
	<20080215155332.2b89c429@core>
	<1203111956.22915.24.camel@pasglop>
	<DD1DA785-AD9C-4EFA-94E2-FA7154EECA9F@ngndg.com>
	<47C347C3.40404@garzik.org>
	<1203987502.15052.71.camel@pasglop>
	<Pine.LNX.4.64.0803260023030.1539@axis700.grange>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 00:31:19 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> pata_sil680 is broken on Linkstation amd Kurobox HG machines since 2.6.24. 
> Work around the breakage until a real fix is found.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Just disable the mmio patch on all systems - we know it doesn't work, we
know what work needs to be done, it should remain off for everyone until
that work is done. It should never have been merged in the first place
and I think my statement to that effect has been proven nicely.

Alan
