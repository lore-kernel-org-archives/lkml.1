Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYJJJaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYJJJaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYJJJ3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:29:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54229 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751340AbYJJJ3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:29:54 -0400
Date: Fri, 10 Oct 2008 10:29:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/1] SIGWINCH problem with terminal apps still alive
Message-ID: <20081010102906.7fb17d4a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081010031234.4030b176@merlin.oi.pg.gda.pl>
References: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
	<20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
	<20081006202834.5b6c5092@merlin.oi.pg.gda.pl>
	<20081006231434.7aaa41ee@lxorguk.ukuu.org.uk>
	<20081007222857.11f92ca0@merlin.oi.pg.gda.pl>
	<20081010031234.4030b176@merlin.oi.pg.gda.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 03:12:34 +0200
Adam Tlałka <atlka@pg.gda.pl> wrote:

> Welcome,
> 
> now we have 2.6.26.6 kernel and still terminal resize leads to
> undesired effects. It is very inconvenient to wait for 2.6.27 for
> corrections.
> 
> As Alan Cox previously said mutexes generally work but as we can
> observe in case of kill_pgrp() call inside mutex lock we got
> race because of rescheduling so lock is not working here.
> Rearanging code so the variable change is placed before kill_pgrp()
> call removes mentioned race situaction.   
> 
> Signed-off-by: Adam Tla/lka <atlka@pg.gda.pl>
> 
> I strongly suggest to patch actual 2.6.26.x kernel to remove this very
> nasty pts behaviour.

NAK again

Moving the copies around simply moves the race, it might be that it fixes
your box and unfixes other peoples.
