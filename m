Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbYKSWrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbYKSWrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYKSWrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:47:33 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:43675 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbYKSWra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:47:30 -0500
Date: Wed, 19 Nov 2008 17:47:29 -0500
To: Fredrik Markstr?m <fredrik.markstrom@avalonenterprise.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Developing non-commercial drivers ?
Message-ID: <20081119224729.GG5682@csclub.uwaterloo.ca>
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com> <20081119183809.GF5682@csclub.uwaterloo.ca> <fc262dee0811191432w7e24dabbyb2b9eff1b8a33d77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc262dee0811191432w7e24dabbyb2b9eff1b8a33d77@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 11:32:04PM +0100, Fredrik Markstr?m wrote:
> Well, who knows ? If you read my email carefully enough you should see
> that that is not the question or issue here.
> This was my first question to this list ever and I'm impressed with
> the good and constructive answers I've gotten, but I really do not
> understand the purpose of your response.

I am one of the (apparently few) people that think when someone asks me
to do something counter productive and most likely misguided, I should
help them by educating them in how they are wrong, not just go do what
they want.

So if your client (or potential client) asks you to write a closed
source driver which would potentially be a licence violation (don't ask
me, ask a lawyer, etc), when there is no reason it should be closed
source, then you should go educate them about why it makes no sense to
make it closed source.  If they get educated and hence now know more,
hopefully they will be smart enough to now not ask for a closed source
driver, and now the legal problems evaporate and you don't have to deal
with lawyers at all (always a good thing).

The customer is NOT always right.  Sometimes the customer just doesn't
have all the facts to know what is the right choice.

So that was my point.

In the case of an ethernet mac, there can't be anything new that needs
protecting (not that reverse engineering the binary for the driver is
necesarily that hard either, so at best it is slowing down, not
protecting really), although I suppose for a wireless ethernet device
some people would claim the FCC and the like insist on not letting users
be able to change some stuff, and again they claim they are protecting
the device by using closed drivers.

You asked a good question, and got a bunch of answers.  I hope the end
result is another fully open source driver that can end up included in
the kernel.  That of course is another bonus worth pointing out.
Drivers included in the kernel are easily an order of magnitude less
work to maintain, since large kernel structure changes are done for you,
rather than you having to catch up later when it is harder to figure out
what they change was done and what you have to do to fix it.

-- 
Len Sorensen
