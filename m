Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZKQXVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZKQXVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZKQXVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:21:54 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:34872 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZKQXVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:21:54 -0500
Date: Wed, 18 Nov 2009 00:22:05 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-mips@linux-mips.org
Subject: Re: [patch 08/13] mips: Fixup last users of irq_chip->typename
Message-ID: <20091117232205.GB1866@linux-mips.org>
References: <20091117224852.846805939@linutronix.de> <20091117224916.642102675@linutronix.de> <20091117230544.GA1866@linux-mips.org> <alpine.LFD.2.00.0911180007340.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911180007340.24119@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 12:09:19AM +0100, Thomas Gleixner wrote:

> > > The typename member of struct irq_chip was kept for migration purposes
> > > and is obsolete since more than 2 years. Fix up the leftovers.
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ralf Baechle <ralf@linux-mips.org>
> > > Cc: linux-mips@linux-mips.org
> > 
> > Looks good.  I assume you want to merge the whole series via tip, so
> > 
> > Acked-by: Ralf Baechle <ralf@linux-mips.org>
> 
> You can pick it up as well. The patches are independent, just the last
> one which removes typename from irq_chip depends on the arch patches
> being merged. Either way works fine.

Okay, queued for 2.6.33 then.

Thanks!

  Ralf
