Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYITWHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYITWHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 18:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYITWHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 18:07:45 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:59701 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbYITWHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 18:07:44 -0400
Message-ID: <48D5742F.6080305@free.fr>
Date: Sun, 21 Sep 2008 00:07:43 +0200
From: Chris Moore <moore@free.fr>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Russ Dill <russ.dill@gmail.com>,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement	ARRAY_SIZE().
References: <20080918132447.516309749@fluff.org.uk>	<20080918150624.GA3421@x200.localdomain>	<f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com>	<20080919065426.GA7222@lenovo>	<f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com>	<f9d2a5e10809190828g54a824b9od1ade53c96a518c8@mail.gmail.com>	<20080919175544.GA3228@x200.localdomain> <48D4F519.2080509@weinigel.se>
In-Reply-To: <48D4F519.2080509@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel a écrit :
> Alexey Dobriyan wrote:
>   
>> On Fri, Sep 19, 2008 at 08:28:45AM -0700, Russ Dill wrote:
>>     
>>> My vote is for ARRAY_AND_SIZE to spread far and wide across the land.
>>> ARRAY_SIZE is already very safe, as it has a __must_be_array macro
>>> built in. So ARRAY_AND_SIZE is even safer, as it prevents you from
>>> mixing up two different arrays. It also reduces line length and makes
>>> driver and device (usually platform_device) registration code easier
>>> to read.
>>>       
>> It also spreads ARRAY_SIZE misnaming futher.
>>     
>
> You still haven't explained what's misnamed about it, nor suggested a 
> better name.
>   

ARRAY_LENGTH and ARRAY_AND_LENGTH would be better names IMHO.

AIUI the usual convention is to use :-
- "size" for the size in the sizeof sense; i.e. (in most 
implementations) the size in _bytes_,
- "length" for the size in the sense of the number of _elements_ in an 
array (sizeof(array) / sizeof((array)[0])) which seems to be the 
intention here.

Cheers,
Chris


