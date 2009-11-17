Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZKQXJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZKQXJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZKQXJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:09:26 -0500
Received: from www.tglx.de ([62.245.132.106]:45553 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbZKQXJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:09:25 -0500
Date: Wed, 18 Nov 2009 00:09:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ralf Baechle <ralf@linux-mips.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-mips@linux-mips.org
Subject: Re: [patch 08/13] mips: Fixup last users of irq_chip->typename
In-Reply-To: <20091117230544.GA1866@linux-mips.org>
Message-ID: <alpine.LFD.2.00.0911180007340.24119@localhost.localdomain>
References: <20091117224852.846805939@linutronix.de> <20091117224916.642102675@linutronix.de> <20091117230544.GA1866@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Ralf Baechle wrote:

> On Tue, Nov 17, 2009 at 10:51:03PM -0000, Thomas Gleixner wrote:
> 
> > The typename member of struct irq_chip was kept for migration purposes
> > and is obsolete since more than 2 years. Fix up the leftovers.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Cc: linux-mips@linux-mips.org
> 
> Looks good.  I assume you want to merge the whole series via tip, so
> 
> Acked-by: Ralf Baechle <ralf@linux-mips.org>

You can pick it up as well. The patches are independent, just the last
one which removes typename from irq_chip depends on the arch patches
being merged. Either way works fine.

Thanks,

	tglx
