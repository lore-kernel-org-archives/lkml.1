Return-Path: <linux-kernel-owner+w=401wt.eu-S1751950AbXB1VD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbXB1VD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXB1VD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:03:58 -0500
Received: from ozlabs.org ([203.10.76.45]:37537 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXB1VD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:03:57 -0500
Subject: Re: [patch 04/26] Xen-paravirt_ops: Add pagetable accessors to
	pack and unpack pagetable entries
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
In-Reply-To: <20070228083203.GB8866@elte.hu>
References: <20070227081337.434798469@goop.org>
	 <20070227081630.311681690@goop.org> <20070227100850.GA10827@elte.hu>
	 <45E47DEF.70405@goop.org>  <20070228083203.GB8866@elte.hu>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 08:02:50 +1100
Message-Id: <1172696571.10271.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-28 at 09:32 +0100, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > >> +#ifdef CONFIG_PARAVIRT
> > >> +/* After pte_t, etc, have been defined */
> > >> +#include <asm/paravirt.h>
> > >> +#endif
> > >>     
> > >
> > > hm - there's already a CONFIG_PARAVIRT conditional in 
> > > asm-i386/paravirt.h.
> > 
> > Yes, but it happens after asm/paravirt.h has already included some 
> > things, and it ends up causing problems.  paravirt.h still defines 
> > various stub functions in the !CONFIG_PARAVIRT case, so it needs to do 
> > the includes either way.
> 
> hm, it then needs to be fixed first, instead of adding to the mess.

Yes, originally paravirt.h didn't define anything if !CONFIG_PARAVIRT
for this reason: getting it tied into the other headers correctly is a
PITA.

Rusty.


