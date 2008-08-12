Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbYHLHER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbYHLHER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYHLHEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:04:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51611 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYHLHD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:03:59 -0400
Date: Tue, 12 Aug 2008 09:05:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       tj@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, hancockr@shaw.ca
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Message-ID: <20080812070505.GX9038@one.firstfloor.org>
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com> <20080811202731.GB2916@elte.hu> <20080811210140.GW9038@one.firstfloor.org> <8db1092f0808112250y6b52a4ben879d83deda6496ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8db1092f0808112250y6b52a4ben879d83deda6496ce@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 07:50:09AM +0200, Maciej Rutecki wrote:
> 2008/8/11 Andi Kleen <andi@firstfloor.org>:
> [...]
> >
> > You can verify this by booting with pci=nommconf. If it works
> > then it's likely that.
> >
> [...]
> 
> It doesn't help

Then mmconfig is not the problem. Must be something else.

In the worst case you can always bisect I guess.

-Andi
