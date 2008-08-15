Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbYHOPn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbYHOPn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbYHOPnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:43:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34174 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756041AbYHOPnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:43:49 -0400
Date: Fri, 15 Aug 2008 16:26:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25.11-97.fc9 (P): idr_remove called for id=236 which is not
 allocated
Message-ID: <20080815162638.013ee0f8@lxorguk.ukuu.org.uk>
In-Reply-To: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
References: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
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

> idr_remove called for id=236 which is not allocated.
> Pid: 3019, comm: a.out Tainted: P         2.6.25.11-97.fc9.i686 #1
>  [<c04f030c>] idr_remove+0xd5/0x138

There were (and probably are) tty races and there might be some more so
I'd actually be interested to know if its repeatable and if you can
provide the test code that triggers it.

Could be nVidiot stuff but quite frankly it looks like a quite believable
real pty layer race in areas of code that were touched recently.

Alan
