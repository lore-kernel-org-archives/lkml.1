Return-Path: <linux-kernel-owner+w=401wt.eu-S1764354AbXGUTOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764354AbXGUTOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXGUTOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:14:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57127 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbXGUTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:14:34 -0400
Date: Sat, 21 Jul 2007 21:14:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use menuconfig objects - Fusion
In-Reply-To: <Pine.LNX.4.64.0707211501570.5853@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707212112060.21737@fbirervta.pbzchgretzou.qr>
References: <200705102317.l4ANHrUC001117@shell0.pdx.osdl.net>
 <Pine.LNX.4.64.0707182035080.5385@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707211501570.5853@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 21 2007 15:05, Robert P. J. Day wrote:
>> +menuconfig FUSION
>...
>> +if FUSION
>>
>>  config FUSION_SPI
>...
>> +endif # FUSION
>
>  i just *know* i'm going to regret asking this, but is there a
>compelling reason why the internal contents of a "menuconfig FUBAR"
>needs to still be surrounded by a "if FUBAR" condition?

Note that if/endif actually translates to a "depends on" for every
contained object. I prefer the reduced clutter [if/endif] over having
explicit depends on on every object, since it is redundant.

>wouldn't it
>be philosophically cleaner if the internals of a menuconfig structure
>*automatically* depended on selection of the menuconfig and the "if"
>part was implicit?

"menuconfig" is not a start marker like "menu" was. Hence it has no "stop"
marker either. We would need a new object type for that.

>  and having said that, i realize that there are menuconfig examples
>for which the above is not strictly true, but i can't remember where
>i've seen them.  all i remember about them is that they we're a bit
>confusing.


	Jan
-- 
