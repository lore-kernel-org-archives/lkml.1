Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXBXM75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXBXM75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 07:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXBXM75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 07:59:57 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:38696 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbXBXM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 07:59:56 -0500
Message-ID: <45E036AB.9050303@student.ltu.se>
Date: Sat, 24 Feb 2007 13:59:23 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Vojtech Pavlik <vojtech@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Milind Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
References: <3b44d3fb0702230215o2fbd5a3y25729e481a447149@mail.gmail.com> <45DEF5EE.4030002@student.ltu.se> <d120d5000702230657s1860efb3o6986277901f13d03@mail.gmail.com> <45DF1165.2080003@student.ltu.se> <d120d5000702230905r6b50a1bbm3b71551f855cdf01@mail.gmail.com> <45DF2F57.2080309@student.ltu.se> <d120d5000702231037q511f8073n47beed320f097458@mail.gmail.com> <45DF3C53.4030100@student.ltu.se> <d120d5000702231358j55cd6665x2add335ceb904c22@mail.gmail.com> <45DF6E20.9060604@student.ltu.se> <20070224111124.GB3609@suse.cz>
In-Reply-To: <20070224111124.GB3609@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech Pavlik wrote:
> On Fri, Feb 23, 2007 at 11:43:44PM +0100, Richard Knutsson wrote:
>
>   
>> Is the reason for the modulo to put a bitmask larger then the variable 
>> into an array?
>>     
>
> The complementary LONG() macro will tell you the index of an array of
> longs where the bit should be set.
>   
This may be a little OT, but how come it is not done as an function? 
Maybe something like "(set/get)_long_mask(...)".
>   
>> The reason I don't like it with modulo is simply because it hides 
>> potential bugs (when x is to big). 
>>     
>
> That would be my only concern - losing compiler warnings.
>   
And what bugs me is that this will effect the whole tree for a feature 
used in only input, right?
>   
>> And what about the "1%"?
>>     
>
> The 1% will need either LLBIT or an extra % 8.
>   
Oh, that's true

Richard Knutsson

