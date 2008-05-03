Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbYECOoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbYECOoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 10:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbYECOn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 10:43:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52067 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755825AbYECOnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 10:43:55 -0400
Date: Sat, 3 May 2008 15:35:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland Dreier <rdreier@cisco.com>, "Moore\, Eric" <Eric.Moore@lsi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: HELP:  Is writeq an atomic operation??
Message-ID: <20080503153521.1d6705cd@core>
In-Reply-To: <481BB512.6030101@zytor.com>
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
	<ada63tw494z.fsf@cisco.com>
	<481BB512.6030101@zytor.com>
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

> > I don't have an authoritative answer, but I can say that I coded
> > drivers/infiniband/hw/mthca and .../mlx4 assuming that writeq() is
> > atomic in the sense that you say, and no one has reported any problems.
> > 
> 
> If you're not under lock you're screwed on a 32-bit platform.

So what cycles does an MMX, SSE or double float store generate on the
bus ?

Alan
