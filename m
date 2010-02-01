Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab0BAMsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:48:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47529
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab0BAMsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:48:00 -0500
Date: Mon, 01 Feb 2010 04:48:13 -0800 (PST)
Message-Id: <20100201.044813.27473014.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: jeff@garzik.org, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/68] ide2libata
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100201114824.29682015@lxorguk.ukuu.org.uk>
References: <20100201110723.54870f7f@lxorguk.ukuu.org.uk>
	<20100201.031725.144446744.davem@davemloft.net>
	<20100201114824.29682015@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 1 Feb 2010 11:48:24 +0000

> On Mon, 01 Feb 2010 03:17:25 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
>> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> Date: Mon, 1 Feb 2010 11:07:23 +0000
>> 
>> > I'm amazed that you'd suggest trashing the current ATA stack to make the
>> > maintenance of the old ones easier - which aren't supposed to be in flux
>> > in the first place.
>> 
>> I'm not, I'm saying leave the ATA stack as it is, but make the IDE
>> legacy layer such that PATA drivers can compile into it.
> 
> I don't see the use of that either. The work has sone use in figuring out
> what the technical differences are between the old and new, and to review
> differences to see why the exist and if they matter.

And if you find the differences and that they matter, what are
you going to do, only fix things in one direction?

That won't make any sense.

And if the goal is to sort things out and keep things in sync,
what better way than to keep then physically in sync?

> The old drivers contain a fair amount of crap, magic and gueswork so a
> good deal of human analysis and testing is needed to move any change
> around and prove it's real and valid not guesswork and fudging.

And then once that hard work is done, we kind of just toss it
for one side of the equation?
