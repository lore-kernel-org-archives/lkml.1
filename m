Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab0CCUZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:25:37 -0500
Received: from mail2.shareable.org ([80.68.89.115]:55118 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab0CCUZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:25:32 -0500
Date: Wed, 3 Mar 2010 20:24:57 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100303202457.GO14694@shareable.org>
References: <1266979632.23523.1668.camel@pasglop> <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com> <20100226210030.GC23933@n2100.arm.linux.org.uk> <1267316072.23523.1842.camel@pasglop> <1267440154.23333.44.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267440154.23333.44.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> > I wonder if it's time to get a PG_arch_2 :-)
> 
> As an optimisation, I think this would help (rather than always
> invalidating the I-cache in update_mmu_cache or set_pte_at).

If PG_arch_{1,2} are used in the same way on all architectures, when
they are used at all, perhaps they should be renamed :-)

-- Jamie
