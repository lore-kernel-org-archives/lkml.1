Return-Path: <linux-kernel-owner+w=401wt.eu-S1762476AbXLRSOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762476AbXLRSOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbXLRSOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:14:25 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:53224 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbXLRSOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:14:24 -0500
Date: Tue, 18 Dec 2007 19:14:23 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: James Nichols <jamesnichols3@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
In-Reply-To: <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr>
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com> 
 <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr> 
 <83a51e120712180734i334399dbl51f44fe32d815f7d@mail.gmail.com> 
 <Pine.LNX.4.64.0712181704380.4422@fbirervta.pbzchgretzou.qr> 
 <83a51e120712180845k6cadf67bn5dd66fb2d3ac72d4@mail.gmail.com> 
 <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr>
 <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 18 2007 13:09, James Nichols wrote:
>
>> >> Well you could still blame Java. I am sure that if you program was C,
>> >> the problem could be narrowed down much easier.
>> >
>> >That may very well be true, but I can't rewrite the whole 500K line
>> >application in C at this point.  Plus, it's a web app which would be
>> >"fun" to implement in C.
>>
>> Well I do not require you to do /that/, but you could try adhering to
>> the unix philosophy later on that one program should do (ideally) one
>> thing, and if the java blob already serves the webpage, then opening
>> sockets and doing xyz could probably live in another program.
>
>Fair enough.  So if the application was written in C, how would that
>make this problem any easier to narrow down?
>
Here is a purely hypothethical (and in practice unlikely) idea:
Java opens up too many sockets (more than you really request) and the
kernel, for whatever reason, does not deliver packets to programs
which have maxed out their fds. Well it would already help if the
java blob was split into multiple blobs (assuming the problem
persists), as the best testcase is the smallest possible one. So if
it is reproducable without the web blob, great step there.
