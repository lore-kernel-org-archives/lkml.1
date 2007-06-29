Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbXF2HUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbXF2HUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXF2HUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:20:13 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:59020 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXF2HUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:20:12 -0400
Date: Fri, 29 Jun 2007 09:20:16 +0200
From: DervishD <lkml@dervishd.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: USB card reader and HAL
Message-ID: <20070629072016.GA22715@DervishD>
Mail-Followup-To: Kay Sievers <kay.sievers@vrfy.org>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070628214351.GA9632@DervishD> <3ae72650706282222u6e5094ffp8e77c0735f39e43d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ae72650706282222u6e5094ffp8e77c0735f39e43d@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Kay :)

 * Kay Sievers <kay.sievers@vrfy.org> dixit:
> On 6/28/07, DervishD <lkml@dervishd.net> wrote:
> >    When I insert a card in the reader, it is not detected, no udev
> >event is generated and I have to do things like "hdparm -z /dev/sda" to
> >"probe" the card. Moreover, I have to do the same when removing the card
> >or the /dev/sdaX nodes are not deleted.
> >
> >    Is HAL the only way of making it work? Is there any CONFIG_ thing
> >I've forgotten in my kernel?
> 
> You have to open() the device node to trigger events from the kernel,
> the kernel itself will not do that for you. HAL polls the device every
> few seconds.

    So, opening the node and checking for ENOMEDIUM is the only
solution... Polling looks like a waste of time, and given that I use the
reader once a month or so, HAL will be a waste of resources. I'll resort
to manually do "hdparm -z" (or something similar) when I need to insert
or remove a card.

    Thanks for confirming, Kay :))

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
