Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbXIYPrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbXIYPrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbXIYPrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:47:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36038 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbXIYPrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:47:39 -0400
Date: Tue, 25 Sep 2007 17:47:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Newall <david@davidnewall.com>, "Serge E. Hallyn" <serge@hallyn.com>,
       Bill Davidsen <davidsen@tmr.com>, Philipp Marek <philipp@marek.priv.at>,
       7eggert@gmx.de, majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
In-Reply-To: <20070925164806.4cadc6a5@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0709251746200.945@fbirervta.pbzchgretzou.qr>
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
 <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5>
 <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com>
 <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com>
 <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com>
 <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com>
 <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com>
 <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com>
 <20070925164806.4cadc6a5@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 25 2007 16:48, Alan Cox wrote:
>David Newall <david@davidnewall.com> wrote:
>> Alan Cox wrote:
>>>>
>>>> Marek's loading dynamic libraries, it seems clear that the prime
>>>> purpose of chroot is to aid security.  Being able to cd your way
>>>> out is handy
>>>
>>> Does it - I can't find any evidence for that.
>>
>> It seems self-evident to me.  What do you think is it prime purpose?
>
>Debugging and testing. At least that is as I understand it much of where
>it came from.
>
>>> A root user can get out of a chroot a million different ways

Uhm, you _do_ have considered the case of setuid(non-0)-after-chroot,
have not you?
