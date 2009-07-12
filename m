Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZGLXWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZGLXWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 19:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZGLXWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 19:22:05 -0400
Received: from ozlabs.org ([203.10.76.45]:40456 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZGLXWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 19:22:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Date: Mon, 13 Jul 2009 08:51:55 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com> <200907121928.28887.rusty@rustcorp.com.au> <20090712083227.39939849@infradead.org>
In-Reply-To: <20090712083227.39939849@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907130851.56161.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 01:02:27 am Arjan van de Ven wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Yes, maybe that's better than kmalloc.  On my laptop I have 105
> > modules loaded, with 3778464 total length: I'm wasting 206944 bytes
> > on unused tails of pages.  But that's only 0.06% of my memory.
>
> 105 is also a sign that you picked a somewhat suboptimal config...
> that's of course your choice but it's a choice that has a small price,
> if you don't want to pay that price, changing the config to not be
> entirely insane is a good answer as well ;-)

To be clear: I run distro kernels on my laptop (Ubuntu in this case).  I think 
this is what we should be optimizing for, or we should offer the distros 
something better than modules.

Cheers,
Rusty.




