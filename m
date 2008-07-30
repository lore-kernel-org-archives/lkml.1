Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbYG3XH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbYG3XH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYG3XHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:07:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44201 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbYG3XHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:07:17 -0400
Date: Wed, 30 Jul 2008 23:49:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: commit a352def21a642133758b868c71bee12ab34ad5c5 broke pptp.
Message-ID: <20080730234933.00e5200b@lxorguk.ukuu.org.uk>
In-Reply-To: <f19298770807301311j1c742979je87ec7edfbf85173@mail.gmail.com>
References: <f19298770807231111p2aaa2a3eyc4bf0c084c626c9b@mail.gmail.com>
	<f19298770807280350r79b2811er79061bb4fa363369@mail.gmail.com>
	<f19298770807301311j1c742979je87ec7edfbf85173@mail.gmail.com>
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

>     Fix ldisc module autoloading.
> 
>     Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>

Yep - I broke it and the patch to fix it will go in the tty fixes push
tomorrow. Your change is overcomplex. It's sufficient if it fails just to
retry once for any error. 

Alan
