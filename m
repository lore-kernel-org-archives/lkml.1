Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbXBWSQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbXBWSQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbXBWSQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:16:07 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:46912 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbXBWSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:16:06 -0500
Message-ID: <45DF2F57.2080309@student.ltu.se>
Date: Fri, 23 Feb 2007 19:15:51 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Milind Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
References: <3b44d3fb0702222056k1d2a9b57q69a3555a09a9058e@mail.gmail.com>	 <3b44d3fb0702230014x4ee4a1dewdc624c54b3635e15@mail.gmail.com>	 <45DEAC45.7090105@student.ltu.se>	 <3b44d3fb0702230215o2fbd5a3y25729e481a447149@mail.gmail.com>	 <45DEF5EE.4030002@student.ltu.se>	 <d120d5000702230657s1860efb3o6986277901f13d03@mail.gmail.com>	 <45DF1165.2080003@student.ltu.se> <d120d5000702230905r6b50a1bbm3b71551f855cdf01@mail.gmail.com>
In-Reply-To: <d120d5000702230905r6b50a1bbm3b71551f855cdf01@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> I was not talking about name (I hate BITWRAP) but behavior.
Oh, my bad :)
>
>> but mainly since it only enables wrapping of the long-type.
>
> I'd provde BIT and separate LLBIT for ones who really need long long.
> People who intereseted in smaller than BITS_PER_LONG bitmaps shoud use
> your proposal - BIT(x % DESIRED_WITH) and BIT should do modulo
> BITS_PER_LONG internally.
I agree that _if_ there is a "BITWRAP" then it should be long, but I 
don't see the reason for it to be in bitops.h when it is only input.h 
that uses it. + I find it different with BIT since it works as well with 
'char' as 'long'.
Also, I think it would be best if the name indicated it is a 'long'.

Am a little bit curious why you would like it in bitops.h, but won't 
complain if you do (think you have noticed my view of it ;))

Richard Knutsson

