Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbZFVQR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbZFVQR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZFVQRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:17:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35337 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbZFVQRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:17:48 -0400
Message-ID: <4A3FAD94.1050806@cs.helsinki.fi>
Date: Mon, 22 Jun 2009 19:13:08 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       akpm@linux-foundation.org, sam@ravnborg.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 2/5] x86: use asm-generic/dma-mapping-common.h
References: <20090620155605.GD12901@elte.hu>	 <20090622135717T.fujita.tomonori@lab.ntt.co.jp>	 <1245650501.18751.0.camel@penberg-laptop>	 <20090622203333U.fujita.tomonori@lab.ntt.co.jp>	 <19f34abd0906220459w39271e29x99d578d0a49d593b@mail.gmail.com>	 <19f34abd0906220543v64b5418di8b97d36214d093cc@mail.gmail.com>	 <20090622124916.GA30553@elte.hu>	 <1245676212.15580.68.camel@pc1117.cambridge.arm.com>	 <1245676935.6227.5.camel@penberg-laptop> <1245684281.15580.102.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1245684281.15580.102.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> kmemleak: Do not force the slab debugging Kconfig options
> 
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> Selecting DEBUG_SLAB or SLUB_DEBUG by the KMEMLEAK menu entry may cause
> issues with other dependencies (KMEMCHECK). These configuration options
> aren't strictly needed by kmemleak but they may increase the chances of
> finding leaks. This patch also updates the KMEMLEAK config entry help
> text.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
