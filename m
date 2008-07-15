Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYGOCRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYGOCRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbYGOCR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:17:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60131
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755948AbYGOCR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:17:26 -0400
Date: Mon, 14 Jul 2008 19:17:27 -0700 (PDT)
Message-Id: <20080714.191727.223788995.davem@davemloft.net>
To: jeff@garzik.org
Cc: dwmw2@infradead.org, david@lang.hm, arjan@infradead.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <487C0788.7030907@garzik.org>
References: <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
	<1216082213.27455.109.camel@shinybook.infradead.org>
	<487C0788.7030907@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 14 Jul 2008 22:12:24 -0400

> David Woodhouse wrote:
> > But since I wanted this tree to be uncontentious and obviously the
> > correct thing to do, I've dropped the drivers/net changes for now
> > anyway.
> > 
> > It's odd that this request has suddenly come out of the blue when we've
> > been using request_firmware() from modules for years already.
> 
> Why is it out of the blue to worry about a working driver suddenly 
> ceasing to work?
> 
> This has nothing to do with request_firmware() itself -- its about 
> having the infrastructure in place so that users do not notice the switch.

And I want to reiterate my adversion to the folks who keep saying
that being opposed to request_firmware() is just like being opposed
to modules.

That's is very far from the truth.

When module support was added, guess what?  I could still build a
completely static kernel image like I always could.

And in fact, to this day, that's what I personally do because that's
how I like my kernels.

But this request_firmware() change does not allow one to get what he
could get before, which is a completely self-contained driver module
object file.

This is the difference between providing an option and making
something mandatory.  This firmware split up is now mandatory.
