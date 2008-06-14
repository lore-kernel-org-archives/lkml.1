Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYFNJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYFNJqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYFNJqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:46:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55089 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755615AbYFNJql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:46:41 -0400
Date: Sat, 14 Jun 2008 10:29:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "R.L. Horn" <lists@eastcheap.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <20080614102900.6830ed46@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    Setting the baud rate to B0 clears both (as per SUS).
> 
>    Subsequently setting the baud rate to something other than B0 leaves the
>    control lines low.
> 
> As it happens, apart from the fact that it breaks minicom, I actually prefer 
> this behavior.

What happens after you go from B0->Banythingelse should depend on the
termios settings at that point. This sounds like a bug therefore.

If you want that behaviour intentionally set B0, after this termios
call then set CLOCAL before changing the baud back.

I'll take a look at this next week.

Alan
