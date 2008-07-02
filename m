Return-Path: <linux-kernel-owner+w=401wt.eu-S1763109AbYGBKFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763109AbYGBKFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 06:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYGBKFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 06:05:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59086 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbYGBKFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:05:02 -0400
Date: Wed, 2 Jul 2008 10:44:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: caglar@pardus.org.tr
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       greg@kroah.com, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Alan Cox <alan@redhat.com>
Subject: Re: [patch 1/9] TTY: fix for tty operations bugs
Message-ID: <20080702104422.57acdf2e@lxorguk.ukuu.org.uk>
In-Reply-To: <200807021257.47593.caglar@pardus.org.tr>
References: <20080701151057.930340322@mini.kroah.org>
	<20080701151859.GB3536@suse.de>
	<20080701160132.GA4496@suse.de>
	<200807021257.47593.caglar@pardus.org.tr>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> drivers/net/hamradio/mkiss.c: In function 'ax_xmit':
> drivers/net/hamradio/mkiss.c:548: error: 'struct tty_struct' has no member named 'drivers'
> drivers/net/hamradio/mkiss.c:549: error: 'struct tty_struct' has no member named 'chars_in_buffer'
> drivers/net/hamradio/mkiss.c:552: warning: format '%s' expects type 'char *', but argument 3 has type 'int'
> drivers/net/hamradio/mkiss.c:552: error: expected ';' before ')' token
> drivers/net/hamradio/mkiss.c:552: error: expected statement before ')' token

Eugene Teo posted the patch to fix that.

Alan
