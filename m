Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYJOJDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYJOJDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJOJDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:03:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33154 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752111AbYJOJDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:03:15 -0400
Date: Wed, 15 Oct 2008 10:02:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20081015100247.1dc2d99f@lxorguk.ukuu.org.uk>
In-Reply-To: <20081015095916.f30c0979.sfr@canb.auug.org.au>
References: <20081015095916.f30c0979.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/mfd/wm8350-core.c: In function 'wm8350_device_init':
> drivers/mfd/wm8350-core.c:1220: error: 'NO_IRQ' undeclared (first use in this function)
> 
> Caused by commit ebccec0fa4e35dff0c18663a492a65f4dc6cad7a ("mfd: Add
> WM8350 interrupt support").

Should just be testing !irq

> 
> I applied the following (probably incorrect) patch.  Maybe this driver
> needs to be restricted to certain architectures?  (NO_IRQ appears to only
> be defined for arm, blackfin, powerpc, mn10300 and parisc)

NO_IRQ is an old IDE private define that some people kept abusing
