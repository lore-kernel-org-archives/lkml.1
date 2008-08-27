Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYH0J6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYH0J6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYH0J57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:57:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47210 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754120AbYH0J56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:57:58 -0400
Date: Wed, 27 Aug 2008 09:39:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Tim Anderson" <tanderson@mvista.com>
Cc: <dedekind@infradead.org>, <Bruce_Leonard@selinc.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-mtd-bounces@lists.infradead.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
       "'Bruce Leonard'" <brucle@earthlink.net>
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
Message-ID: <20080827093920.1bdb44c2@lxorguk.ukuu.org.uk>
In-Reply-To: <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
References: <1219817017.18027.149.camel@sauron>
	<000201c9080d$0bce0d20$6b01a8c0@mvista.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008 23:20:46 -0700
"Tim Anderson" <tanderson@mvista.com> wrote:

> Artem,
> 
> I see your point. Ioctls are going away after all.

I don't know where that stupid story keeps coming from. Ioctl is alive
and well and there are more not less of them. There are lots of things
you *cannot* do with sysfs, including synchronization and handling
many kinds of changes to objects that can appear and disappear. Ditto
there are problems with getting a consistent snapshot via sysfs because
you can't atomically read multiple fields.

So please stop this 'ioctls are going away' stuff, its bunkum.

Alan
