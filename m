Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYESPYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYESPYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYESPY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:24:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60599 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751966AbYESPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:24:28 -0400
Date: Mon, 19 May 2008 16:12:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, corbet@lwn.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
Message-ID: <20080519161224.030b82c3@core>
In-Reply-To: <483191F9.3010706@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
	<20080519123111.97C0C1B41FF@basil.firstfloor.org>
	<20080519140339.GB24267@infradead.org>
	<483191F9.3010706@firstfloor.org>
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

On Mon, 19 May 2008 16:43:05 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> 
> > I'd rather do a properly flag day and move lock_kernel into the
> > instances instead of adding this _unlocked gunk.
> 
> I've considered that, but it's a bit too many fasync instances
> all over the tree, so I chose this method.

If I can do all the watchdog drivers in one go then we can do all the
fasync interfaces in one go. It isn't that hard other than making sure
people didn't hide them in odd places on platforms not usually built.

Alan
