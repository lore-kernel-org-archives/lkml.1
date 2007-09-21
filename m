Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbXIUNxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbXIUNxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758183AbXIUNxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:53:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55389 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbXIUNxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:53:24 -0400
Date: Fri, 21 Sep 2007 15:53:23 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Peter Stahlir <peter.stahlir@googlemail.com>
cc: Muhammad Tayyab <mail.tayyab@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Git as a filesystem
In-Reply-To: <fbe8b1780709210630x492779f0s76322394467ff76b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709211552240.30810@fbirervta.pbzchgretzou.qr>
References: <fbe8b1780709210348n1b1bd739rf5bfe0a73381b3ec@mail.gmail.com> 
 <46F3AAC1.5050409@gmail.com>  <fbe8b1780709210437s18b24945jab5a3ffa07646427@mail.gmail.com>
  <fbe8b1780709210446i24a7ee84reaa232be2d3d089e@mail.gmail.com> 
 <Pine.LNX.4.64.0709211449370.30810@fbirervta.pbzchgretzou.qr>
 <fbe8b1780709210630x492779f0s76322394467ff76b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 21 2007 15:30, Peter Stahlir wrote:
>
>> >For example, imagine running a complete Debian mirror on top of a
>> >Debian system with gitfs. How big would the packfile be for this 252GB
>> >beast?
>>
>> Probably 252 GB. Lots of the packages are already compressed, and
>> each time a minimal change is done, the bytestream changes, so long
>> story short, deltifying between to compressed streams is likely to
>> deltify horribly.
>
>What about adding deb or tar support to git?

Blatant layering violation.

>Then git doesn't store deb archives but the contents of archives.

And waht about metadata (e.g. rpm Vendor: tag)? tar does not store that.

>This way redundancy across architectures can be deltified.

Not at all. Different instruction sets, different codes ==> delta -> 0.
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

