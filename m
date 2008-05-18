Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYERKKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYERKKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 06:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYERKKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 06:10:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37241 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752589AbYERKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 06:10:36 -0400
Date: Sun, 18 May 2008 10:54:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Gilles Espinasse" <g.esp@free.fr>
Cc: "Adrian Bunk" <bunk@kernel.org>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses
 ofIRQF_SAMPLE_RANDOM
Message-ID: <20080518105444.5ac3ebf4@core>
In-Reply-To: <10a001c8b8b2$28afd2c0$f9b5a8c0@pii350>
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>
	<20080515142154.0595e475@core>
	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>
	<482C7B18.6060003@garzik.org>
	<482C7E53.3050300@hp.com>
	<482C8184.2030906@garzik.org>
	<20080516161029.44ded734@core>
	<0f7201c8b790$9c2a2340$f9b5a8c0@pii350>
	<20080517220258.GC8140@cs181133002.pp.htv.fi>
	<10a001c8b8b2$28afd2c0$f9b5a8c0@pii350>
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

> Why remove IRQF_SAMPLE_RANDOM if "it cannot make the RNG output worse."
> We should not care if network traffic can be sniffed in some configurations
> (plus sniffing could be very unlikely in some others).

It makes it much worse - it lies about entropy.

> My understanding of openssl developper answer is same as yours :
> "it cannot make the RNG output worse."

If you don't care about the quality of your "random" numbers then
use /dev/urandom. It's very simple.
