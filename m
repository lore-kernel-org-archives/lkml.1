Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0CKVtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:49:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:34215 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab0CKVtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:49:13 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org,
       linux@arm.linux.org.uk, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, Catalin Marinas <catalin.marinas@arm.com>,
       bigeasy@linutronix.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-sh@vger.kernel.org, santosh.shilimkar@ti.com,
       Pavel Machek <pavel@ucw.cz>, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100310035249.GB17693@linux-sh.org>
References: <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
	 <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com>
	 <20100304154103.GA9384@linux-sh.org>
	 <1267726049.6526.543.camel@e102109-lin.cambridge.arm.com>
	 <1267738660.22204.77.camel@pasglop> <20100305011745.GC26618@linux-sh.org>
	 <1267764295.22204.102.camel@pasglop>  <20100310035249.GB17693@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 08:44:31 +1100
Message-ID: <1268343871.22204.709.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 12:52 +0900, Paul Mundt wrote:
> Well, it does start to get a bit painful with sparsemem section or
> NUMA
> node IDs also digging in to the page flags on 32-bit.. the benefits
> would
> have to be pretty compelling to offset the pain. 

Unless we play a dangerous trick and re-use another flag that isn't
meaningful for allocated pages... maybe PG_buddy ? Or do I miss
something about that guy semantics ?

Cheers,
Ben.

