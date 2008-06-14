Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYFNVev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYFNVev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYFNVel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:34:41 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:39365 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbYFNVek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:34:40 -0400
Message-ID: <4854396E.6040308@skyrush.com>
Date: Sat, 14 Jun 2008 15:34:38 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48438126.3080308@t-online.de>	 <20080604171056.GB17875@devserv.devel.redhat.com>	 <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>	 <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>	 <485323C5.4030002@skyrush.com>	 <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>	 <48540343.4010200@skyrush.com>	 <19f34abd0806141334w67547e84hf1021c0fd1139b8b@mail.gmail.com>	 <48542F75.5070605@skyrush.com> <19f34abd0806141426o7ba13f91h6720db3609146e16@mail.gmail.com>
In-Reply-To: <19f34abd0806141426o7ba13f91h6720db3609146e16@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> I'm not sure it is. Try adding sleep 3 instead. Because I have the
> "sleep 2" when I run "su foo" as well, and I _didn't_ put it there:
> 
> [pid  6298] execve("/bin/sleep", ["sleep", "2"], [/* 47 vars */]
> <unfinished ...>

Weird!  OK, I tried it with "sleep 3" in .bashrc, and it says
"...execve("/usr/bin/sleep", ["sleep", "3"], [/* 30 vars */]) = 0".
This sounds like what I'd expect.  I don't understand why you see a
sleep 2 when you did not have one in your config.....

	-Joe
