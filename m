Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbXG2F1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbXG2F1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 01:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXG2F13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 01:27:29 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:27925 "EHLO
	asav07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbXG2F12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 01:27:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXAIjBq0ZKhRO4Rmdsb2JhbACBToVqiCQBAQEWDQYMAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: fernando@oss.ntt.co.jp
Subject: Re: [PATCH] fix return value of i8042_aux_test_irq
Date: Sun, 29 Jul 2007 01:27:25 -0400
User-Agent: KMail/1.9.3
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       vojtech@suse.cz, akpm@linux-foundation.org
References: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp> <20070726162913.2dc9a9b2@the-village.bc.nu> <2090.172.50.1.13.1185465429.squirrel@172.19.0.2>
In-Reply-To: <2090.172.50.1.13.1185465429.squirrel@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707290127.26058.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007 11:57, fernando@oss.ntt.co.jp wrote:
> On Fri, July 27, 2007 12:29 am, Alan Cox wrote:
> >> > A small number of boxes do share IRQ12 and it was switched to shared
> >> for
> >> > them.
> >> If that is the case interrupt handlers should be able to determine
> >> whether
> >> a certain interrupt comes from their respective devices, and return
> >> IRQ_HANDLED or IRQ_NONE accordingly. Returning IRQ_HANDLED
> >> unconditionally
> >> when IRQF_SHARED is set seems strange. Is this behavior intended?
> >
> > Sometimes you simple can't tell and in those cases you have no choice.
> As I mentioned in a previous email, i8042_interrupt considers that it
> should not handle an interrupt when there is no data to read and,
> accordingly, it returns IRQ_NONE in such cases. I was just wondering if we
> could follow the same approach to make i8042_aux_test_irq more
> IRQF_SHARED-friendly.
>

Yes, you are right. Patch applied to 'for-linus' branch of input tree.

Thank you.

-- 
Dmitry
