Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYG2Jah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYG2Jah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYG2Ja2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:30:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39722 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753005AbYG2Ja2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:30:28 -0400
Date: Tue, 29 Jul 2008 10:12:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasily Averin <vvs@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Vasily Averin <vvs@sw.ru>
Subject: Re: [PATCH]: Proposed fix to the I2O problems with > 4GB space
Message-ID: <20080729101233.1db63218@lxorguk.ukuu.org.uk>
In-Reply-To: <488EE175.8040607@parallels.com>
References: <20080725131637.48072ef3@lxorguk.ukuu.org.uk>
	<20080729004756.113d85a0.akpm@linux-foundation.org>
	<488ED4CF.1000402@parallels.com>
	<20080729095122.7021ddd0@lxorguk.ukuu.org.uk>
	<488EE175.8040607@parallels.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 13:23:01 +0400
Vasily Averin <vvs@parallels.com> wrote:

> Alan Cox wrote:
> >> One of our test nodes uses i2o controller. Now this node have 6 Gb memory and
> >> quite a long time it works well under 64-bit RHEL5-based kernel. I'm not sure is
> >> i2o card really 64-bit capable, but dmesg shows that it uses 64-bit dma.
> > 
> > Do you use the i2o config interfaces and driver ?
> 
> When I loaded i2o_config module and read all entries in /proc/i2o/ directory the
> node hung.
> 
> Do you mean that you have fixed this issue?

I think I have yes
