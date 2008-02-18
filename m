Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYBRSQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYBRSQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYBRSQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:16:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52411 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYBRSQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:16:29 -0500
Date: Mon, 18 Feb 2008 19:52:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080218185228.GA29026@one.firstfloor.org>
References: <200802171025.30590.elendil@planet.nl> <20080217124650.576990ce@laptopd505.fenrus.org> <p73mypyxx6z.fsf@bingen.suse.de> <20080218085018.05f3190a@laptopd505.fenrus.org> <20080218171159.GA24090@basil.nowhere.org> <20080218093215.5cf611a8@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218093215.5cf611a8@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've yet to see a user who wants WC. Lets face it, WC *sucks*. This is why

Interesting.
 
> the folks who care about performance (the graphics guys) stopped using it.

I didn't know this. What do they do instead?

I understand that WC was added originally because AGP was really slow
at IO towards the CPU. You mean on PCI-E it is fast enough now
that standard cached WB works well enough?

> WC is slow, and on modern cpus leads to really bad performance. I'm really
> half tempted to just ignore WC entirely and suggest that we don't even implement
> it in the kernel. Yes it's really that bad.

At least the X server still uses it. In fact there are already some
performance regression regarding this from differing kernel behavioun
in the sysfs interfaces vs /dev/mem.

What would you recommend should the X server use instead? Always
map standard WB?  How about on older AGP systems?

-Andi

