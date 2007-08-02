Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbXHBNiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbXHBNiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbXHBNiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:38:10 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54474 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbXHBNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:38:09 -0400
Date: Thu, 2 Aug 2007 15:38:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Herbert Rosmanith <kernel@wildsau.enemy.org>, linux-kernel@vger.kernel.org
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <46B1D708.9040106@msgid.tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0708021536350.24572@fbirervta.pbzchgretzou.qr>
References: <200708021056.l72Au722008603@wildsau.enemy.org>
 <Pine.LNX.4.64.0708021347270.24572@fbirervta.pbzchgretzou.qr>
 <46B1D708.9040106@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 17:07, Michael Tokarev wrote:
>Jan Engelhardt wrote:
>> On Aug 2 2007 12:56, Herbert Rosmanith wrote:
>>>> On Aug 2 2007 12:42, Herbert Rosmanith wrote:
>>>> There never *were* days when eth0 remained eth0 across such changes.
>>> but there *were* days when eth0 was eth0, if the kernel reports it as such.
>>> now there is no eth0 at all. if I see an "eth0" from dmesg, I expect
>>> it to be present.
>> 
>> Wait, you forget that something may change the name. That dmesg message
>> from 1 second ago does not need to be valid anymore, just as anything
>> else in this world.
>
>That was my argument - there should be no way to *change* the name, but
>to give an alias(es) - entirely different thing.

Ah, in that case, make the kernel print the PCI-ID instead of the name.
(Or perhaps both together.)


As for userspace, you are free to do whatever you find most useful.



	Jan
-- 
