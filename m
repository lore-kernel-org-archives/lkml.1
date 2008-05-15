Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbYEOQu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbYEOQu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYEOQuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:50:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59638 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754007AbYEOQuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:50:46 -0400
Date: Thu, 15 May 2008 17:39:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: "Chris Peterson" <cpeterso@cpeterso.com>, <jeff@garzik.org>,
       <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
Message-ID: <20080515173939.1ec968be@core>
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>
	<20080515142154.0595e475@core>
	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>
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

> In short, I agree with Alan's IRQF_SAMPLE_DUBIOUS, and know of Linux
> customers who also want the same.

They should be made to read the Debian ssh security report - three times
and understand the same would apply to them if something did cause their
network packet arrivals to be observed or non-random

Far better would be to get your CPU guys to put an RNG back into the
systems or on the CPU die ala VIA. Given I've even seen people using VIA
boxes as a random number feeder (streaming random numbers over SSL) there
is clearly a demand 8)

Alan
