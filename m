Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbYDKIdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYDKIdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757827AbYDKIcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:32:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47996 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757402AbYDKIcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:32:53 -0400
Date: Fri, 11 Apr 2008 09:28:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-ID: <20080411092840.3cc4de67@core>
In-Reply-To: <20080411075515.GH26777@enneenne.com>
References: <20080410160630.GA24885@enneenne.com>
	<1207851751-25703-1-git-send-email-giometti@linux.it>
	<1207851751-25703-2-git-send-email-giometti@linux.it>
	<1207851751-25703-3-git-send-email-giometti@linux.it>
	<1207851751-25703-4-git-send-email-giometti@linux.it>
	<1207851751-25703-5-git-send-email-giometti@linux.it>
	<1207851751-25703-6-git-send-email-giometti@linux.it>
	<20080410210918.3be98868@core>
	<20080411075515.GH26777@enneenne.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How can I do that? From a serial device I just need the IRQ time
> arrival, no other data at all. How a ldisc can help me in this task?

At the moment you can't. That needs fixing. Most of the infrastructure is
there but not all of it.

> This patch adds PPS support just for UARTs, other devices should
> provide their own support by using the new provided API. :)

I do not want PPS code adding to every single serial driver. That way
lies madness. We do it once, and in the right layer. I'll take a further
look at it after the tty->ops patch is merged. At that point we'll be in
a good position to add the needed ops/callbacks.

Alan
