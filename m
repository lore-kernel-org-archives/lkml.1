Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZKEK1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZKEK1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 05:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZKEK1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 05:27:15 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:49659 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbZKEK1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 05:27:15 -0500
Date: Thu, 5 Nov 2009 11:28:38 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
       huhb@lemote.com, yanh@lemote.com, Zhang Le <r0bertz@gentoo.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: Re: [PATCH -queue v0 1/6] [loongson] add basic loongson-2f support
Message-ID: <20091105102838.GF12582@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com> <a1bd2470bc465e505281c761adca8c2287d102b3.1257325319.git.wuzhangjin@gmail.com> <20091105091841.GC12582@linux-mips.org> <1257414523.1824.11.camel@falcon.domain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257414523.1824.11.camel@falcon.domain.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 05:48:43PM +0800, Wu Zhangjin wrote:

> > I thought the Loongson 2E/2F were MIPS64 Release 1 compatible?
> > 
> 
> They told me MIPS III, but added MMX instruction set ;)

Just when I thought MIPS III was on the way out ;-)

> > You're ifdefing on Loongson 2F - doesn't that mean that you can't have a
> > kernel that supports both Loongson 2E and 2F?
> > 
> 
> Currently, not consider it yet;) It's a little hard to cope with, should
> we consider it at this moment? if yes, I will try it with the help of
> exisiting machtype asap. but I think it's better to let it be the future
> job ;)

Fair enough - though I'm sure Linux distributions would be happy to have
one kernel variant less to ship.

> > static struct irqaction __maybe_unused dma_timeout_irqaction = {
> > [...]
> > };
> > 
> 
> okay, will apply it later.

Thanks.

  Ralf
