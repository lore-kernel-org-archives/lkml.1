Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbXGIMWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbXGIMWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXGIMWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:22:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55419 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751981AbXGIMWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:22:09 -0400
Date: Mon, 9 Jul 2007 14:22:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] include/asm-mips/processor.h: "extern inline" ->
	"static inline"
Message-ID: <20070709122240.GY3492@stusta.de>
References: <20070707010330.GY3492@stusta.de> <20070709102754.GB24487@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070709102754.GB24487@linux-mips.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 11:27:55AM +0100, Ralf Baechle wrote:
> On Sat, Jul 07, 2007 at 03:03:30AM +0200, Adrian Bunk wrote:
> 
> > "extern inline" will have different semantics with gcc 4.3,
> > and "static inline" is correct here.
> 
> The idea was to have a linker error in case gcc should deciede for some
> reason not to inline this function

If that's the intention, please use __always_inline instead.

> which as I understand will continue
> to be the behaviour of gcc 4.3?

In C99 (and therefore in gcc >= 4.3), "extern inline" means that the 
function should be compiled inline where the inline definition is seen, 
and that the compiler should also emit a copy of the function body with 
an externally visible symbol.

You don't want this.

>   Ralf

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

