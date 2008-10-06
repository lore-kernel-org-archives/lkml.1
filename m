Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYJFWQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYJFWQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 18:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYJFWPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 18:15:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37967 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338AbYJFWPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 18:15:54 -0400
Date: Mon, 6 Oct 2008 23:14:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/0] SIGWINCH problem with terminal apps
Message-ID: <20081006231434.7aaa41ee@lxorguk.ukuu.org.uk>
In-Reply-To: <20081006202834.5b6c5092@merlin.oi.pg.gda.pl>
References: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
	<20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
	<20081006202834.5b6c5092@merlin.oi.pg.gda.pl>
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

> > show up more. Later 2.6.27-rc has patches that use the termios lock
> > across TIOCG/SWINSZ and deal with the problem properly.
> 
> Maybe but what with older versions. Anyway the problem is if mutexes
> are usable here or not.

Well if mutexes don't work your kernel will eat your computer fairly
rapidly so I think we may safely conclude that mutex locks work
