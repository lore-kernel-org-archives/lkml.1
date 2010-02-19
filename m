Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0BSUxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 15:53:42 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:49112 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0BSUxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:53:40 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Fri, 19 Feb 2010 21:53:22 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
References: <1266445892.16346.306.camel@pasglop> <1266599755.32546.38.camel@e102109-lin.cambridge.arm.com> <1266601011.32546.48.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1266601011.32546.48.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002192153.22159.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 19. Februar 2010 18:36:51 schrieb Catalin Marinas:
> If a page is already mapped in user space, flush_dcache_page() on ARM
> does the flushing rather than deferring it to update_mmu_cache(). The
> PIO HCD drivers, however, don't call flush_dcache_page(). Is it possible
> that the HCD could transfer data into a page cache page already mapped
> in user space? My understanding is that the scenario above is possible.

Yes, video drivers do that.

	Regards
		Oliver
