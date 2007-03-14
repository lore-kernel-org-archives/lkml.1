Return-Path: <linux-kernel-owner+w=401wt.eu-S933806AbXCNC1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806AbXCNC1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 22:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933807AbXCNC1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 22:27:19 -0400
Received: from ozlabs.org ([203.10.76.45]:57135 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933806AbXCNC1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 22:27:18 -0400
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <45F6DC27.8000200@goop.org>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
	 <1173185909.4644.36.camel@localhost.localdomain>
	 <1173186021.4644.38.camel@localhost.localdomain>
	 <1173186107.4644.41.camel@localhost.localdomain>
	 <1173186214.4644.44.camel@localhost.localdomain>
	 <45F6DC27.8000200@goop.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 13:27:10 +1100
Message-Id: <1173839230.5443.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 10:15 -0700, Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > +	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
> > +			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
> > +			__per_cpu_offset[cpu], 0xFFFFF,
> >  			0x80 | DESCTYPE_S | 0x2, 0); /* present read-write data segment */
> >   
> 
> Why testing with qemu is not enough.

Indeed 8(.

Thanks!
Rusty.

