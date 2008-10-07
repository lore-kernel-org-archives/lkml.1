Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYJGUa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYJGUa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYJGU3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:29:53 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:50957 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYJGU3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:29:51 -0400
Date: Tue, 7 Oct 2008 22:28:57 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/0] SIGWINCH problem with terminal apps
Message-ID: <20081007222857.11f92ca0@merlin.oi.pg.gda.pl>
In-Reply-To: <20081006231434.7aaa41ee@lxorguk.ukuu.org.uk>
References: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
	<20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
	<20081006202834.5b6c5092@merlin.oi.pg.gda.pl>
	<20081006231434.7aaa41ee@lxorguk.ukuu.org.uk>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, 6 Oct 2008 23:14:34 +0100 - Alan Cox <alan@lxorguk.ukuu.org.uk>:

> > > show up more. Later 2.6.27-rc has patches that use the termios
> > > lock across TIOCG/SWINSZ and deal with the problem properly.
> > 
> > Maybe but what with older versions. Anyway the problem is if mutexes
> > are usable here or not.
> 
> Well if mutexes don't work your kernel will eat your computer fairly
> rapidly so I think we may safely conclude that mutex locks work
> 

OK, so if this race problem raises only while kill_pgrp() is
used the proposed patch eliminates this problem. Of course we should
change code in all places where pgrp_kill() is used in conjuction
with mutexes and some internal variables are modified.
What do you think about it?

Regards

-- 
Adam Tlałka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gdańsk University of Technology, Poland
