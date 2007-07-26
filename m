Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbXGZPXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbXGZPXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXGZPWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:22:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51472 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728AbXGZPWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:22:53 -0400
Date: Thu, 26 Jul 2007 16:29:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: fernando@oss.ntt.co.jp
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       Fernando Luis =?UTF-8?B?VsODwqF6cXVleg==?= Cao 
	<fernando@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, vojtech@suse.cz,
       akpm@linux-foundation.org
Subject: Re: [PATCH] fix return value of i8042_aux_test_irq
Message-ID: <20070726162913.2dc9a9b2@the-village.bc.nu>
In-Reply-To: <1446.172.50.1.13.1185461396.squirrel@172.19.0.2>
References: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp>
	<d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
	<20070726151042.0ae34e0e@the-village.bc.nu>
	<1446.172.50.1.13.1185461396.squirrel@172.19.0.2>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > A small number of boxes do share IRQ12 and it was switched to shared for
> > them.
> If that is the case interrupt handlers should be able to determine whether
> a certain interrupt comes from their respective devices, and return
> IRQ_HANDLED or IRQ_NONE accordingly. Returning IRQ_HANDLED unconditionally
> when IRQF_SHARED is set seems strange. Is this behavior intended?

Sometimes you simple can't tell and in those cases you have no choice.

Alan
