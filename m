Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbXKKHeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbXKKHeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 02:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXKKHem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 02:34:42 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:40280 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751407AbXKKHel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 02:34:41 -0500
Date: Sun, 11 Nov 2007 16:34:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] add -fno-tree-scev-cprop to KBUILD_CFLAGS
Message-ID: <20071111073422.GA25323@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
	linux-kernel@vger.kernel.org
References: <20071111064829.GG21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071111064829.GG21669@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 07:48:29AM +0100, Adrian Bunk wrote:
> But the kernel does (at least on some architectures) not link with 
> libgcc or ship other code providing the required libgcc functions.
> 
> Richard Guenther suggested in gcc bug #32044 to use -fno-tree-scev-cprop 
> (new option in gcc 4.3) as a workaround and I confirmed that it fixes 
> the compilation.
> 
And some architectures do link it in, so the call to libgcc code doesn't
necessarily matter. Perhaps the architectures that don't link in libgcc
can turn this flag on conditionally, it shouldn't be forced on the
architectures that do link it in.
