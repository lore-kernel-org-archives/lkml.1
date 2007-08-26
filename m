Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXHZSnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXHZSnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXHZSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 14:43:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45497 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbXHZSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 14:43:07 -0400
Date: Sun, 26 Aug 2007 20:43:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mike Frysinger <vapier@gentoo.org>
cc: parisc-linux@lists.parisc-linux.org, sparclinux@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       parisc-linux@parisc-linux.org
Subject: Re: [parisc-linux] errno codes intertwined
In-Reply-To: <200708261345.43165.vapier@gentoo.org>
Message-ID: <Pine.LNX.4.64.0708262038170.12920@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708241815540.28540@fbirervta.pbzchgretzou.qr>
 <200708261345.43165.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26 2007 13:45, Mike Frysinger wrote:
>> can I rely on the same errno across Linuxes?
>
>nope
>
>> And should the errno values be fixed up?
>
>i guess that depends on whether you think it's even broken :)
>
>no spec requires any errno symbol have an exact numeric value ... i'm guessing 
>your FUSE is only cross-Linux and you're not planning on dipping into any 
>other OS ?

If the errnos are not the same in the Linux world, it's not even
cross-Linux ;-) - but it's always translated to fixed numbers now anyway.

I have not really thought about putting it in use on other systems yet. I
don't have macosx to test, and Windows generally lacks some fuses. :^)
You are free to spin it if you like, http://freshmeat.net/p/ccgfs/


	Jan
-- 
