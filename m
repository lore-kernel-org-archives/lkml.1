Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbZGFPbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbZGFPbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZGFPbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:31:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57263 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751139AbZGFPbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:31:42 -0400
Date: Mon, 6 Jul 2009 16:32:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael Guntsche <mike@it-loops.com>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090706163239.3f557b45@lxorguk.ukuu.org.uk>
In-Reply-To: <20090706083119.GA17782@gondor.apana.org.au>
References: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com>
	<20090627140643.7140f6a9@lxorguk.ukuu.org.uk>
	<33C7D336-F062-47B3-9033-D3DC465F793C@it-loops.com>
	<20090706074333.GA17276@gondor.apana.org.au>
	<20090706083119.GA17782@gondor.apana.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's the stupidest possible fix for this, changing the mutex
> to a spin lock.  We should also revert the other commit that

Crashes my box immediately. The unthrottle methods call sleeping driver
functions with real hardware so

NAK

If it was that simple I'd have done this ages ago. It has to be fixed
properly, and that is hard.

Alan
