Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYKZARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYKZARt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYKZARl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:17:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36459 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752317AbYKZARk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:17:40 -0500
Date: Wed, 26 Nov 2008 00:16:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memcg reclaim shouldn't change zone->recent_rotated
 statics.
Message-ID: <20081126001650.280530d0@lxorguk.ukuu.org.uk>
In-Reply-To: <20081126091027.3CA6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081125121842.26C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081125155422.6ab07caf.akpm@linux-foundation.org>
	<20081126091027.3CA6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> however, "_p" isn't linux convention.
> so, I like "is_" or "can_" (or likes somethingelse) prefix :)

_p is from lisp but Ted did sneak tty_hung_up_p() into the kernel many
years ago.
