Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbZCVTBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbZCVTBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZCVTBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:01:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40266 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbZCVTBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:01:22 -0400
Message-ID: <49C68AFB.6010301@zytor.com>
Date: Sun, 22 Mar 2009 12:01:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Baybal Ni <nikulinpi@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: My new fancy font for framebuffer
References: <ff479ab60903210945p51c78f4fgf434d159e880de95@mail.gmail.com>	 <20090321111520.5fb73195@infradead.org> <49C5BBE8.6010906@zytor.com> <ff479ab60903220222w1d10da15xd446fb4eabfde4d1@mail.gmail.com>
In-Reply-To: <ff479ab60903220222w1d10da15xd446fb4eabfde4d1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Baybal Ni wrote:
>>>
>> Either way, the terminus font by Dimitar Zhekov is GPL 2.  This probably
>> means that distributing it without distributing the source format or
>> "the preferred form for editing" is illegal in jurisdictions where
>> bitmap fonts are copyrightable.  The preferred format for editing the
>> terminus font appears to be BDF.
> 
> BDF is a compilled format itself. Technicaly it is still 100% the same
> bitmap (Just a one giant bitmap + markup about character sizes).
> So these way we just effectively ... decompiled it to the same it's
> source which could be distributed under GPL. Which is totally ok with
> GPL.
> 

That's a very... liberal... interpretation of the license.  I think it's
pretty safe to say that C source code is *NOT* the preferred format.
That being said, there is no fundamental reason why the BDF and the
resulting processing can't be included in the kernel.

>> That, combined with the sheer number of character subsets one can get
>> out of the extremely rich terminus font would again mean that the kbd
>> project is a better place for it.
> 
> Cut everything below 255
> 
> Yes, but we want it to be bundled in kernel, for me it is the only
> option for systems with qvga screens or so on. Old fonts were nice
> only on CRT displays, but on TFTs they are giving too much load on
> eyes and brain. More clean contoured fonts are effectively cutting it.

Why do we want it bundled on the kernel?  Why can't you just run setfont
from your startup scripts like everyone else?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

