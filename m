Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbZACUan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbZACUan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZACUad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:30:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51100 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751571AbZACUad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:30:33 -0500
Date: Sat, 3 Jan 2009 20:30:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
 from unsigned long
Message-ID: <20090103203044.0166b561@lxorguk.ukuu.org.uk>
In-Reply-To: <20090103202740.GC1666@elf.ucw.cz>
References: <20090103124400.GA1572@ucw.cz>
	<20090103201955.186974bb@lxorguk.ukuu.org.uk>
	<20090103202740.GC1666@elf.ucw.cz>
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

> If it is okay and linux relies on it, it should be documented.
> 
> If it is not okay, I guess we should document it, too -- it seems to
> be common mistake. 

A lot of old code did it knowing it was under the BKL, outside of the BKL
its a very bad idea. There were lots of them in the tty layer and I don't
doubt there are some left I missed too 8(
