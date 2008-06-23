Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbYFWUK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbYFWUK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYFWUKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:10:50 -0400
Received: from www17.your-server.de ([213.133.104.17]:33822 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYFWUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:10:49 -0400
Message-ID: <1214251844.486003446b64c@213.133.104.17>
Date: Mon, 23 Jun 2008 22:10:44 +0200
From: Thomas Meyer <thomas@m3y3r.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: rpjday@crashcourse.ca, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at kernel/workqueue.c:169 (was: linux-next: Tree for June 16)
References: <20080616190103.c3271e3e.sfr@canb.auug.org.au> <1213651727.3275.3.camel@dhcppc4> <1213987718.3134.7.camel@dhcppc4> <200806231315.54490.rusty@rustcorp.com.au>
In-Reply-To: <200806231315.54490.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 84.59.62.125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zitat von Rusty Russell <rusty@rustcorp.com.au>:

> On Saturday 21 June 2008 04:48:37 Thomas Meyer wrote:
> > I tried to bisect this one, but without a consistent result.
> 
> That's always suspicious...
> 
> > Another thing i tried is to change <linux/kernel.h>:
> 
> This will also cause almost everything to be rebuilt.  I find it hard to 
> believe this is the culprit; does a "make clean" also fix it?
> 
Sorry! I compared the created binary and both are equal. So above commit
revertion or the change of linux/kernel.h has nothing to do with the non
working usb wlan stick.

Sometimes it works, sometimes not. And when it's non-working then i also get the
BUG at kernel/workqueue in my dmesg.
 

Sorry for all the bustle.

greets
thomas



