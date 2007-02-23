Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXBWOuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXBWOuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932447AbXBWOuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:50:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:49456 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbXBWOui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:50:38 -0500
To: David Miller <davem@davemloft.net>
Cc: tglx@linutronix.de, jengelh@linux01.gwdg.de, kronos.it@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck
References: <1172099859.25076.132.camel@localhost.localdomain>
	<Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
	<1172159501.25076.182.camel@localhost.localdomain>
	<20070222.092652.55507017.davem@davemloft.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Feb 2007 16:50:24 +0100
In-Reply-To: <20070222.092652.55507017.davem@davemloft.net>
Message-ID: <p738xeodgan.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
> 
> BTW, sparc64 always did the trick where the do_timer() work was done
> by one of the per-cpu local timer interrupts, I'm glad the idea gained
> traction generically. :-)))

It was already implemented before for x86-64, but disabled 
by default because it ran into some platform issues. The new code
hopefully knows now how to work around them.

-Andi
