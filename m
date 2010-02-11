Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab0BKFgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 00:36:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:51926 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab0BKFgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 00:36:44 -0500
Subject: Re: [PATCH 28/35] radix: move radix init early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <84144f021002100205v7968a342lb315296eccefb523@mail.gmail.com>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	 <1265743966-17065-29-git-send-email-yinghai@kernel.org>
	 <20100209114916.ba38f57f.akpm@linux-foundation.org>
	 <84144f021002091156q5cbf6adcj3c1d86b00a6e5285@mail.gmail.com>
	 <4B71FACB.9040504@kernel.org>
	 <84144f021002100205v7968a342lb315296eccefb523@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 16:29:36 +1100
Message-ID: <1265866176.16346.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> OK, great. Would be good to have some coverage on other architectures
> as well. PPC was one of the archs that blew up last time we changed
> init order.

Hopefully that should be ok. In fact we use the radix tree in our
interrupt handling and today we have a horrible hack that reverts
to linear search early during boot until we can allocate the radix
trees in an arch_initcall.

Thus the patch should allow us to simplify that code and remove
that late init hack.

Cheers,
Ben.


