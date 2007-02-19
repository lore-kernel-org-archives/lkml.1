Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbXBSLEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbXBSLEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbXBSLEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:04:07 -0500
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:48489 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbXBSLEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:04:06 -0500
Message-ID: <45D98420.5060604@tremplin-utc.net>
Date: Mon, 19 Feb 2007 12:04:00 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070215)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: O2micro smartcard reader driver.
References: <20061127182817.d52dfdf1.l.bigonville@edpnet.be>	 <456C0BD0.7080606@tremplin-utc.net>	 <200611281249.45243.oliver@neukum.org>	 <457F1F0F.20109@tremplin-utc.net>	 <d9def9db0702161536i64cf6fb3o1c3c8ff850c38994@mail.gmail.com> <d9def9db0702161955y1543e995o48b63eb1265e22a8@mail.gmail.com>
In-Reply-To: <d9def9db0702161955y1543e995o48b63eb1265e22a8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

02/17/2007 04:55 AM, Markus Rechberger wrote/a écrit:
> Hi Eric,
> 
> I committed your code to linuxtv.org to review and modify it there.
> http://linuxtv.org/hg/~mrechberger/chipcardreader
> 
> one thing I noticed is the error handling in ozscr_probe.
> 
> I'll continue the rest during the next few days, I'd like to see it as
> soon as possible in the upstream kernel before some kernel api changes
> again which affects your current driver.

Hi Markus,

Thank you very much for finding new bugs ;-) Actually, right now I've 
just moved and don't have internet at home which is kind of slowing down 
development... Anyway, I'll check if I have some more fixes on my 
computer than on my website. Also, it would be good to double check some 
lines which I've commented XXX. In particular, IIRC there were some 
suspicious sleep saying it was sleeping a microsecond and sleeping one 
millisecond!

I'm also a bit concerned about the userspace "driver" for pscd which 
comes with the original driver once the patch will be part of the 
default kernel. Maybe this userspace part could become part of the 
pscdlite distribution.

Wrt the module having always a usecount value of 1, it was worrying me 
too at the begining until I noticed it decreased back to 0 once the card 
is "ejected" (pccardctl eject 1). Although a bit surprising, I don't 
think it's a bug, is it?

See you,
Eric

